package com.example.platform_channel
import android.Manifest
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_channel"
    private val PERMISSION_CHANNEL = "sms_permission_channel"
    private val REQUEST_SMS_PERMISSION = 1001
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "requestSmsPermission") {
                val permission = Manifest.permission.READ_SMS
                if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
                    result.success(true)
                } else {
                    pendingResult = result
                    ActivityCompat.requestPermissions(this, arrayOf(permission), REQUEST_SMS_PERMISSION)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            /*if (call.method == "getBkashSmsList") {
                pendingResult = result
                checkPermissionAndFetchSms()
            }*/
            when(call.method){
                "getCashSummary" -> checkPermissionAndFetchSms(result)
                else -> result.notImplemented()
            }
        }
    }

    //check kore permission ache kina dekhe jodi permission thake tahole sathe sathe read kora totalCashIn kore flutter e pathiye dei
    // ar permission na pai then result ta dhore rakhe then permission er jonno request pathai
    private fun checkPermissionAndFetchSms(result: MethodChannel.Result) {
        val permission = Manifest.permission.READ_SMS
        if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
            // Permission granted - fetch SMS
            val total = fetchSms() //double return
            result.success(
                mapOf(
                    "cashIn" to total["cashIn"],
                    "cashOut" to total["cashOut"]
                ))
        } else {
            pendingResult = result
            // Request permission
            ActivityCompat.requestPermissions(this, arrayOf(permission), REQUEST_SMS_PERMISSION)
        }
    }
    // Handle permission result
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == REQUEST_SMS_PERMISSION) {
            val granted =
                grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingResult?.let { result ->
                if (granted) {
                    val total = fetchSms()
                    result.success(
                        mapOf(
                            "cashIn" to total["cashIn"],
                            "cashOut" to total["cashOut"])
                       )
                } else {
                    result.error("PERMISSION_DENIED", "SMS permission denied", null)
                }
                pendingResult = null // reset Pendind result
            }
        }else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    private fun fetchSms(): Map<String,Double>{    //Double { // List<Map<String, Any>> { //funtion return type
        //val smsList = mutableListOf<Map<String, Any>>()
        val uriSms: Uri = Uri.parse("content://sms/inbox")// android e sms database

        val calendar = java.util.Calendar.getInstance() // calender er ekta instance create kora
        calendar.set(java.util.Calendar.DAY_OF_MONTH, 1) //current day jai hok 1 tarikh set kore
        calendar.set(java.util.Calendar.HOUR_OF_DAY, 0) //eikhane hour ke 0 korse
        calendar.set(java.util.Calendar.MINUTE, 0)
        calendar.set(java.util.Calendar.SECOND, 0)
        calendar.set(java.util.Calendar.MILLISECOND, 0) //mili Second reset korse
        val firstDayOfMonth =
            calendar.timeInMillis //calender object er present somoy ke milisecond e convert kora

        //where address like %bKash%
        val selection = "(Address LIKE ? OR body LIKE ?) AND date >= ?"
        val selectionArgs = arrayOf("%bKash%", "%bKash%", firstDayOfMonth.toString())
        var totalCashIn = 0.0
        var totalCashOut = 0.0
        //cash in
        val amountRegex = Regex("""(?i)(cash in|received)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)""")
        //cash out
        val cashOutRegex = Regex("""(?i)(cash out|sent)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)""")

        val cursor: Cursor? = contentResolver.query(
            uriSms,
            null,
            selection,
            selectionArgs,
            "date DESC"
        )
        cursor?.let { // cursor diye sms loop
            if (cursor.moveToFirst()) {
                do {
                    //val address = cursor.getString(cursor.getColumnIndexOrThrow("address"))
                    val body = cursor.getString(cursor.getColumnIndexOrThrow("body"))
                    //val date = cursor.getString(cursor.getColumnIndexOrThrow("date"))

                    //find amount inside SMS body //cash in
                    val match = amountRegex.findAll(body)
                    match.forEach { m ->
                        val numStr = m.groups[2]?.value ?: "0" //for example "40,000.0"
                        val removeStr = numStr.replace(",", "") // remove comma //like "40000.0"
                        val amount = removeStr.toDoubleOrNull() ?: 0.0  /// double e convert 40000.0
                        totalCashIn += amount
                    }
                    //cash out
                    val cashOutMatch = cashOutRegex.findAll(body)
                    cashOutMatch.forEach { m ->
                        val raw = m.groups[2]?.value ?: "0"
                        val clean = raw.replace(",", "")
                        val cashOutAmount = clean.toDoubleOrNull() ?: 0.0
                        totalCashOut += cashOutAmount
                    }
                    /*val map = mapOf(
                        "address" to address,
                        "body" to body,
                        "date" to date)
                    smsList.add(map)
                     */
                } while (cursor.moveToNext())
            }
        }
        cursor?.close()
        //debug print
        println("Total Cash in: $totalCashIn")
        println("Total Cash out: $totalCashOut")

        return mapOf(
            "cashIn" to totalCashIn,
            "cashOut" to totalCashOut
        )}
        //return totalCashIn;
}




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
            if(call.method == "getTotalCashIn"){
                checkPermissionAndFetchSms(result) //pass result here
            }
            else {
                result.notImplemented()
            }
        }
    }

    private fun checkPermissionAndFetchSms(result: MethodChannel.Result) {
        val permission = Manifest.permission.READ_SMS
        if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
            // Permission granted - fetch SMS
            //val smsList = fetchSms()
            val total = fetchSms() //double return
            //pendingResult?.success(total)
            result.success(total)
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
            val granted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
            if (granted) {
                //val smsList = fetchSms()
                //pendingResult?.success(smsList)
                pendingResult?.success(granted)
            } else {
                pendingResult?.error("PERMISSION_DENIED", "SMS permission denied", null)
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    private fun fetchSms(): Double{ // List<Map<String, Any>> { //funtion return type
        //val smsList = mutableListOf<Map<String, Any>>()
        val uriSms: Uri = Uri.parse("content://sms/inbox")// android e sms database

        //where address like %bKash%
        val selection = "address LIKE ? OR body LIKE ?"
        val selectionArgs = arrayOf("%bKash%","%bKash%")
        var totalCashIn = 0.0
        val amountRegex = Regex("""(?i)(cash in|received)\D*(?:Tk\s*|Taka\s*)?([\d,]+(\.\d+)?)""")

        //val amountRegex = RegExp(r"(?i)(cash in|received)\D*(\d+(?:,\d+)?(?:\.\d+)?)"); //eita kaj kor na
        val cursor: Cursor? = contentResolver.query(
            uriSms, null,
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

                    //find amount inside SMS body
                    val match = amountRegex.findAll(body)
                    match.forEach {m ->
                        val numStr = m.groups[2]?.value ?: "0" //for example "40,000.0"
                        val removeStr = numStr.replace(",", "") // remove comma //like "40000.0"
                        val amount = removeStr.toDoubleOrNull() ?: 0.0  /// double e convert 40000.0
                        totalCashIn += amount
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
        return totalCashIn
    }
}

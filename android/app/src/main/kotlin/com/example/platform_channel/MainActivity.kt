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
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "requestSmsPermission") {
                val permission = Manifest.permission.READ_SMS
                if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
                    result.success(true)
                } else {
                    //permission result handle korbe
                    pendingPermissionResult = result
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(permission),
                        REQUEST_SMS_PERMISSION
                    )
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            /*if (call.method == "getBkashSmsList") {
                pendingResult = result
                checkPermissionAndFetchSms()
            }*/
            when (call.method) {
                "getAllSms" -> checkPermissionAndFetchSms(result)
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
            result.success(total)
        } else {
            //sms fetch result handle korbe
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

            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null

            pendingResult?.let { result ->
                if (granted) {
                    val total = fetchSms()
                    result.success(total)
                } else {
                    result.error("PERMISSION_DENIED", "SMS permission denied", null)
                }
                pendingResult = null // reset Pendind result
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    private fun fetchSms(): List<Map<String, Any>> { //funtion return type
        val smsList = mutableListOf<Map<String, Any>>()
        val uriSms: Uri = Uri.parse("content://sms/inbox")// SMS database of android


        val cursor: Cursor? = contentResolver.query(
            uriSms, null, null, null,
            "date DESC"
        )
        cursor?.let { // cursor diye sms loop
            if (cursor.moveToFirst()) {
                do {
                    val address = cursor.getString(cursor.getColumnIndexOrThrow("address"))
                    val body = cursor.getString(cursor.getColumnIndexOrThrow("body"))
                    val date = cursor.getString(cursor.getColumnIndexOrThrow("date"))

                    val map = mapOf(
                        "address" to (address ?: ""),
                        "body" to (body ?: ""),
                        "date" to date
                    )
                    smsList.add(map)

                } while (cursor.moveToNext())
            }
        }
        cursor?.close()
        return smsList;
    }
}




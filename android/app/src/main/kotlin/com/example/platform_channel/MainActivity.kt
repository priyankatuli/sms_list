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
    private val REQUEST_SMS_PERMISSION = 1001
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSmsList") {
                pendingResult = result
                checkPermissionAndFetchSms()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun checkPermissionAndFetchSms() {
        val permission = Manifest.permission.READ_SMS
        if (ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED) {
            // Permission granted - fetch SMS
            val smsList = fetchSms()
            pendingResult?.success(smsList)
        } else {
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
                val smsList = fetchSms()
                pendingResult?.success(smsList)
            } else {
                pendingResult?.error("PERMISSION_DENIED", "SMS permission denied", null)
            }
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    private fun fetchSms(): List<Map<String, Any>> {
        val smsList = mutableListOf<Map<String, Any>>()
        val uriSms: Uri = Uri.parse("content://sms/inbox")// android e sms database

        val cursor: Cursor? = contentResolver.query(uriSms, null, null, null, null)

        cursor?.let {
            if (cursor.moveToFirst()) {
                do {
                    val address = cursor.getString(cursor.getColumnIndexOrThrow("address"))
                    val body = cursor.getString(cursor.getColumnIndexOrThrow("body"))
                    val date = cursor.getString(cursor.getColumnIndexOrThrow("date"))

                    val map = mapOf(
                        "address" to address,
                        "body" to body,
                        "date" to date
                    )
                    smsList.add(map)
                } while (cursor.moveToNext())
            }
        }
        cursor?.close()
        return smsList
    }
}

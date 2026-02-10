package com.example.sus_pro

import android.app.Activity
import android.content.IntentSender
import android.os.Bundle
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "nuPro/location_settings"
	private val REQUEST_CHECK_SETTINGS = 1001

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
			when (call.method) {
				"showLocationSettings" -> {
					showLocationSettings(result)
				}
				else -> result.notImplemented()
			}
		}
	}

	private fun showLocationSettings(result: MethodChannel.Result) {
		try {
			val locationRequest = LocationRequest.create().apply {
				priority = LocationRequest.PRIORITY_HIGH_ACCURACY
				interval = 10000
				fastestInterval = 5000
			}

			val builder = LocationSettingsRequest.Builder().addLocationRequest(locationRequest)
			val client = LocationServices.getSettingsClient(this)
			val task = client.checkLocationSettings(builder.build())

			task.addOnSuccessListener {
				// All good, no need to show dialog
				result.success(true)
			}

			task.addOnFailureListener { exception ->
				if (exception is ResolvableApiException) {
					try {
						// This will show the Google Play Services dialog to enable high accuracy
						exception.startResolutionForResult(this as Activity, REQUEST_CHECK_SETTINGS)
						// We return success here; the actual user choice is handled in onActivityResult
						result.success(true)
					} catch (sendEx: IntentSender.SendIntentException) {
						result.error("intent_error", "Failed to send intent: ${sendEx.message}", null)
					}
				} else {
					result.error("settings_error", "Location settings are inadequate and cannot be fixed here.", null)
				}
			}
		} catch (e: Exception) {
			result.error("exception", e.message, null)
		}
	}

	override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
		super.onActivityResult(requestCode, resultCode, data)
		if (requestCode == REQUEST_CHECK_SETTINGS) {
			// resultCode == Activity.RESULT_OK means the user agreed to make required location settings changes
			if (resultCode == Activity.RESULT_OK) {
				android.util.Log.i("MainActivity", "User enabled location settings via dialog")
			} else {
				android.util.Log.i("MainActivity", "User did NOT enable location settings via dialog")
			}
		}
	}
}

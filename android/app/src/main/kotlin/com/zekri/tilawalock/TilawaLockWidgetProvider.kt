package com.zekri.tilawalock

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class TilawaLockWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val pendingIntent = es.antonborri.home_widget.HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_title, pendingIntent)
                setOnClickPendingIntent(R.id.widget_message, pendingIntent)
                
                val title = "TilawaLock Streak: " + widgetData.getInt("streak", 0).toString()
                val message = widgetData.getString("motivation_message", "Recite to unlock \uD83D\uDCD6")

                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_message, message)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

package com.sinlov.android.plugin;

/**
 * this class can delete if not use Singleton
 */
public final class Plugin {

    private volatile static Plugin instance;

    public static Plugin getInstance() {
        if (null == Plugin.instance) {
            synchronized (Plugin.class) {
                if (Plugin.instance == null) {
                    Plugin.instance = new Plugin();
                }
            }
        }
        return Plugin.instance;
    }

    private Plugin() {

    }
}

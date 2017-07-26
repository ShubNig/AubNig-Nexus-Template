package com.sinlov.android.develophelper;

import android.app.ProgressDialog;

/**
 * for dialog adapter
 * <pre>
 *     sinlov
 *
 *     /\__/\
 *    /`    '\
 *  ≈≈≈ 0  0 ≈≈≈ Hello world!
 *    \  --  /
 *   /        \
 *  /          \
 * |            |
 *  \  ||  ||  /
 *   \_oo__oo_/≡≡≡≡≡≡≡≡o
 *
 * </pre>
 * Created by sinlov on 17/1/18.
 */
public abstract class UXUtilsAdapter {
    private boolean isLock;
    private ProgressDialog pd;

    public boolean isLock() {
        return isLock;
    }

    public void setPd(ProgressDialog pd) {
        this.pd = pd;
    }

    public void unLock() {
        this.isLock = false;
        if (pd != null && pd.isShowing()) {
            pd.hide();
        }
    }

    public void lock() {
        this.isLock = true;
    }

    public abstract void doProgressDialog(ProgressDialog pd);
}

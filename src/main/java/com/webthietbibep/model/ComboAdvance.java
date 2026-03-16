package com.webthietbibep.model;

import java.io.Serializable;

public class ComboAdvance implements Serializable {
    private int combo_id;
    private String advance;

    public ComboAdvance() {
    }

    public ComboAdvance(int combo_id, String advance) {
        this.combo_id = combo_id;
        this.advance = advance;
    }

    public int getCombo_id() {
        return combo_id;
    }

    public void setCombo_id(int combo_id) {
        this.combo_id = combo_id;
    }

    public String getAdvance() {
        return advance;
    }

    public void setAdvance(String advance) {
        this.advance = advance;
    }
}

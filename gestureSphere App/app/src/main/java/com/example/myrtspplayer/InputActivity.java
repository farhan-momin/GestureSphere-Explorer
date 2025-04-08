package com.example.myrtspplayer;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import androidx.appcompat.app.AppCompatActivity;

public class InputActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_input);

        final EditText editTextUrl = findViewById(R.id.editTextUrl);
        Button buttonSubmit = findViewById(R.id.buttonSubmit);

        buttonSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String enteredUrl = editTextUrl.getText().toString();
                Intent intent = new Intent(InputActivity.this, MainActivity.class);
                intent.putExtra("rtspUrl", enteredUrl);
                startActivity(intent);
            }
        });
    }
}


package com.gojjam.bank.listener;

import com.gojjam.bank.service.ScheduledPaymentService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Logger;

@WebListener
public class ScheduledPaymentListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(ScheduledPaymentListener.class.getName());
    private Timer timer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        timer = new Timer("ScheduledPaymentTimer", true);
        ScheduledPaymentService service = new ScheduledPaymentService();

        // Run every 60 seconds
        timer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                try {
                    service.processDue();
                } catch (Exception e) {
                    LOGGER.warning("Scheduled payment engine error: " + e.getMessage());
                }
            }
        }, 60_000L, 60_000L);

        LOGGER.info("Gojjam Bank – Scheduled Payment Engine started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
            LOGGER.info("Gojjam Bank – Scheduled Payment Engine stopped.");
        }
    }
}
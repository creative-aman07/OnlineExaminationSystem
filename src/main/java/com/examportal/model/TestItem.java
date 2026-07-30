package com.examportal.model;

public class TestItem {
    private int testId;
    private String testName;
    private String subject;
    private int durationMinutes;
    private int totalQuestions;
    private String startTime;
    private String endTime;
    // Computed against the database clock: UPCOMING, RUNNING or CLOSED.
    private String status = "RUNNING";

    public TestItem() {
    }

    public TestItem(int testId, String testName, String subject, int durationMinutes, int totalQuestions) {
        this.testId = testId;
        this.testName = testName;
        this.subject = subject;
        this.durationMinutes = durationMinutes;
        this.totalQuestions = totalQuestions;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public String getTestName() {
        return testName;
    }

    public void setTestName(String testName) {
        this.testName = testName;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isRunning() {
        return "RUNNING".equals(status);
    }
}

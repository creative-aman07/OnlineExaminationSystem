package com.examportal.model;

public class Candidate {
    private int candidateId;
    private String fullName;
    private String rollNumber;
    private String email;
    private String createdAt;

    public Candidate() {
    }

    public Candidate(int candidateId, String fullName, String rollNumber, String email, String createdAt) {
        this.candidateId = candidateId;
        this.fullName = fullName;
        this.rollNumber = rollNumber;
        this.email = email;
        this.createdAt = createdAt;
    }

    public int getCandidateId() {
        return candidateId;
    }

    public void setCandidateId(int candidateId) {
        this.candidateId = candidateId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}

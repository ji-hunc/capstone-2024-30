package com.example.capstone.domain.announcement.service;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum AnnouncementUrl {
    KOOKMIN_OFFICIAL("https://www.kookmin.ac.kr/user/kmuNews/notice/index.do", "official"),
    INTERNATIONAL_ACADEMIC("https://cms.kookmin.ac.kr/kmuciss/notice/academic.do", "유학생 학사공지"),
    INTERNATIONAL_VISA("https://cms.kookmin.ac.kr/kmuciss/notice/visa.do", "유학생 비자공지"),
    INTERNATIONAL_SCHOLARSHIP("https://cms.kookmin.ac.kr/kmuciss/notice/scholarship.do", "유학생 장학공지"),
    INTERNATIONAL_EVENT("https://cms.kookmin.ac.kr/kmuciss/notice/event.do", "유학생 행사/취업공지"),
    INTERNATIONAL_PROGRAM("https://cms.kookmin.ac.kr/kmuciss/notice/program.do", "유학생 학생지원공지"),
    INTERNATIONAL_GKS("https://cms.kookmin.ac.kr/kmuciss/notice/gks.do", "유학생 정부초청공지"),
    SOFTWARE_ACADEMIC("https://cs.kookmin.ac.kr/news/notice/", "SW 학사공지"),
    SOFTWARE_JOB("https://cs.kookmin.ac.kr/news/jobs/", "SW 취업공지"),
    SOFTWARE_SCHOLARSHIP("https://cs.kookmin.ac.kr/news/scholarship/", "SW 장학공지"),
    SOFTWARE_EVENT("https://cs.kookmin.ac.kr/news/event/", "SW 특강/행사공지");

    private String url;
    private String type;
}

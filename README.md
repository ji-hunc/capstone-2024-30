## 1. 프로젝트 소개

이 프로젝트는 국민대학교에서 공부하는 외국인 유학생들을 위한 종합적인 앱 서비스를 개발하는 것입니다. 앱은 학생들이 캠퍼스 생활에 빠르게 적응할 수 있도록 다양한 정보와 서비스를 제공합니다.

<br>

## 2. Abstract

This project aims to develop a comprehensive app service for international students studying at Kookmin University. The app provides a variety of information and services to help students quickly adapt to campus life.

<br>

## 3. 소개 영상

프로젝트 소개하는 영상을 추가하세요

<br>

## 4. 팀원 소개

<table>
    <tr align="center">
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/52407470/5a581293-0461-462b-b14d-5c98c079860f" width="250"></td>
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/52407470/074c4543-e44a-4bb6-baf8-7c3f0d9f1e3d" width="250"></td>
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/52407470/7627b57d-585c-4021-b02a-5ae6daded453" width="250"></td>
    </tr>
    <tr align="center">
        <td>최지훈</td>
        <td>김민제</td>
        <td>조현진</td>
    </tr>
    <tr align="center">
        <td>****1683</td>
        <td>****1557</td>
        <td>****1675</td>
    </tr>
    <tr align="center">
        <td>👑 Frontend</td>
        <td>Frontend</td>
        <td>Backend</td>
    </tr>
</table>

<table>
    <tr align="center">
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/53148103/9c6d6e4b-0f85-4489-9f93-f1cf6774fd50" width="250"></td>
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/54922676/cad2c04e-8c71-44c0-9be1-9f29c0244243" width="250"></td>
        <td><img src="https://github.com/kookmin-sw/capstone-2024-30/assets/52407470/1c9ac172-5d97-4002-b254-c003f5d07ac2" width="250"></td>
    </tr>
    <tr align="center">
        <td>채원찬</td>
        <td>김혜성</td>
        <td>최영락</td>
    </tr>
    <tr align="center">
        <td>****1676</td>
        <td>****1582</td>
        <td>****1678</td>
    </tr>
    <tr align="center">
        <td>Backend</td>
        <td>AI</td>
        <td>AI</td>
    </tr>
</table>

<br>

## 5. 기술스택

### Frontend

<div style="display: flex; gap: 6px;">
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
</div>

### Backend

<div style="display: flex; gap: 6px;">
    <img src="https://img.shields.io/badge/spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white">
    <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white">
    <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
</div>

### Tools

<div style="display: flex; gap: 6px;">
    <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">
    <img src="https://img.shields.io/badge/AMAZON AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white"/>
    <img src="https://img.shields.io/badge/slack-4A154B?style=for-the-badge&logo=slack&logoColor=white">
    <img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=Postman&logoColor=white"/>
    <img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white"/>
</div>

<br>

## 6. 시스템 구조

<br>
<img src ="https://github.com/kookmin-sw/capstone-2024-30/assets/55117706/9ca1e9f4-7ac4-4930-b89b-72e4a489035d" width = "800">

## 7. 사용법

### Backend

`.env.example`을 바탕으로 `.env`를 작성합니다. 그 다음

```
chmod +x ./gradlew
./gradlew
```

또는

```
gradle clean build
```

를 통해 실행 .jar 파일을 생성합니다. 실행파일을 생성했으면

```
docker-compose up --build -d
```

를 통해 docker compose build를 진행하여 실행하시면 됩니다.

<br>

### Frontend

#### 1. 플러터 설치

1. Flutter 공식 웹사이트([https://flutter.dev](https://flutter.dev))에 접속
2. `Get Started`를 클릭하여 설치 가이드를 따라 설치
3. 설치가 완료되면, 터미널 또는 커맨드 프롬프트를 열고 `flutter doctor` 명령어를 실행하여 설치가 올바르게 되었는지 확인

#### 2. 프로젝트 디렉토리 이동

```
cd front/capstone_front
```

#### 3. 플러터 패키지 설치

```
flutter pub get
```

#### 4. 프로젝트 실행

```
flutter run
```

<br>

### AI

## 8. 기타

<br>

package com.example.capstone.domain.menu.service;

import com.example.capstone.domain.menu.entity.Menu;
import com.example.capstone.domain.menu.repository.MenuRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.math.NumberUtils;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class MenuService {
    private final MenuRepository menuRepository;

    public void addMenus(LocalDateTime startTime, LocalDateTime endTime, LocalDateTime today) {
        RestTemplate restTemplate = new RestTemplateBuilder().build();
        String sdate = startTime.format(DateTimeFormatter.ISO_LOCAL_DATE);
        String url = "https://kmucoop.kookmin.ac.kr/menu/menujson.php?callback=jQuery112401919322099601417_1711424604017";

        url += "&sdate=" + sdate + "&edate=" + sdate + "&today=" + sdate + "&_=1711424604018";
        String response = restTemplate.getForObject(url, String.class);

        try {
            String json = response.substring(response.indexOf("(") + 1, response.lastIndexOf(")"));
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> allMap = mapper.readValue(json, Map.class);

            for(Map.Entry<String, Object> cafeEntry : allMap.entrySet()) {
                String cafeteria = cafeEntry.getKey();
                for(Map.Entry<String, Object> dateEntry : ((Map<String, Object>) cafeEntry.getValue()).entrySet()) {
                    String dateString = dateEntry.getKey();
                    LocalDateTime date = LocalDate.parse(dateString, DateTimeFormatter.ISO_LOCAL_DATE).atStartOfDay();
                    for(Map.Entry<String, Object> sectionEntry : ((Map<String, Object>) dateEntry.getValue()).entrySet()) {
                        String section = sectionEntry.getKey();
                        String name = "";
                        Long price = 0L;
                        for(Map.Entry<String, Object> context : ((Map<String, Object>) sectionEntry.getValue()).entrySet()) {
                            if(context.getKey().equals("메뉴")) {
                                name = context.getValue().toString();
                            }
                            else if(context.getKey().equals("가격")) {
                                price = NumberUtils.toLong(context.getValue().toString());
                            }
                        }
                        menuRepository.save(Menu.builder().cafeteria(cafeteria).section(section).date(date).name(name).price(price).language("KR").build());
                    }
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void findMenuByDate(LocalDateTime dateTime){
        Optional<Menu> menuList = menuRepository.findMenuByDate(dateTime);
    }
}

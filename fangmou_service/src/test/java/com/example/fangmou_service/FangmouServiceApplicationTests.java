package com.example.fangmou_service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class FangmouServiceApplicationTests {

	@Test
	void contextLoads() {
//		for (TrafficLight light : TrafficLight.values()) {
//			System.out.println(light);
//			System.out.println(light.getClass());
//		}

		System.out.println(TrafficLight.RED.getClass());

	}

}



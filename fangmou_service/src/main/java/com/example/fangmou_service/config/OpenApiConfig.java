package com.example.fangmou_service.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI springShopOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("订单系统 API")
                        .description("基于Spring Boot 3.0")
                        .version("v1.0.0")
                        .contact(new Contact().name("团队").url("https://example.com"))
                );
    }
}

package com.example.fangmou_service.controller;


import com.example.fangmou_service.model.FangmouResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/base")
public class FangmouBaseController {

    @GetMapping("/HelloWorld")
    public String helloWorld(){
        return  "HelloWorld";
    }

    @GetMapping("/TEST")
    public FangmouResponse test(){
        return  FangmouResponse.ok();
    }


}

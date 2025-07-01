package com.example.fangmou_service.model;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

@Data
@Schema(title = "请求相应")
public class FangmouResponse {
    
    @Schema(description = "用户状态")
    private Boolean success;

    @Schema(description = "返回码")
    private Integer code;

    @Schema(description = "返回消息")
    private String message;

    @Schema(description = "返回数据")
    private Map<String, Object> data = new HashMap<String, Object>();

    public static FangmouResponse ok() {
        FangmouResponse r = new FangmouResponse();
        r.setSuccess(true);
        r.setCode(ResultCode.SUCCESS.getCode());
        r.setMessage("成功");
        return r;
    }

    public static FangmouResponse error() {
        FangmouResponse r = new FangmouResponse();
        r.setSuccess(false);
        r.setCode(ResultCode.ERROR.getCode());
        r.setMessage("失败");
        return r;
    }

    public FangmouResponse success(Boolean success) {
        this.setSuccess(success);
        return this;
    }

    public FangmouResponse message(String message) {
        this.setMessage(message);
        return this;
    }

    public FangmouResponse code(Integer code) {
        this.setCode(code);
        return this;
    }

    public FangmouResponse data(String key, Object value) {
        this.data.put(key, value);
        return this;
    }

    public FangmouResponse data(Map<String, Object> map) {
        this.setData(map);
        return this;
    }
}
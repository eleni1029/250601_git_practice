import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI()

# 正確加上 CORS 設定
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://eleni1029.github.io"],  # GitHub Pages 前端網址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class BMIRequest(BaseModel):
    height_cm: float
    weight_kg: float

@app.post("/bmi")
def calculate_bmi(data: BMIRequest):
    try:
        height_m = data.height_cm / 100
        bmi = data.weight_kg / (height_m ** 2)

        if bmi < 18.5:
            category = "過輕"
        elif 18.5 <= bmi < 24:
            category = "正常"
        elif 24 <= bmi < 27:
            category = "過重，請減少壓縮餅乾的攝取"
        else:
            category = "肥胖，請減少每天的麻花攝取"

        return {
            "bmi": round(bmi, 2),
            "category": category
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/")
def root():
    return {"message": "Hello from FastAPI BMI"}

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port)

# **CAU Data Analysis Contest**
![1page](https://user-images.githubusercontent.com/80115212/135949754-c0b149c9-35de-4c62-8555-baa961b3641a.PNG)


<br/>
<br/>

## **1. 프로젝트 소개**
### **1-(1) 대회명**
- 중앙대학교 응용통계학과 데이터 분석 공모전


<br/>


### **1-(2) 프로젝트 주제** 
- 서울시 자동차 극장 최적입지 추천


<br/>


### **1-(3) 프로젝트 기간** 
- 2020.09.20 ~ 2020.11.16


<br/>


## **2. 프로젝트 내용**
### **2-(1) 문제 정의**
- KBO리그 타자를 대상으로 해당 경기 안타 여부를 분류하는 딥러닝 모델 


<br/>


### **2-(2) 분석 목표**
- 다중회귀모형을 통해 서울시 내 자동차 극장 입지 추천   

<br/>


### **2-(3) 데이터 수집 및 전처리**
- 스탯티즈에서 4년도의 타자 90명의 데이터 수집

![data수집](https://user-images.githubusercontent.com/80115212/135566371-7592a0ee-b887-4711-b1bd-a29199fd5ef4.PNG)

- 데이터 정규화(MIN-MAX Scaling) 및 아웃라이어 제거
- 학습 데이터 : 검증 데이터 = 7 : 3

<br/>


### **2-(4) 관련 학습**
- 유사한 연구 논문 리뷰
- MLP, RNN, LSTM 구조
- Python Keras와 Scikit-learn 라이브러리
- MLP 모델 성능 개선 방안
- 과적합(Overfitting) 방지

<br/>


### **2-(5) 모델 설계**
- MLP, RNN, LSTM 사용
- Node, Hidden layer 조절
- Experiment setting
    * Activatoin function: ReLU & Sigmoid(출력층)
    * Loss function: Binary Crossentrophy & Mean Squared Error
    * Weight Initialization : Random Uniform -> He Initialization
    * Optimization : Rmsprop, Adam
    
- Dropout 적용 여부
- 새로운 지표 생성(최근 성적, Home/Away, 상대 vs)

![model](https://user-images.githubusercontent.com/80115212/135570765-67cd9854-e615-419e-afab-6d83c2b41220.PNG)

<br/>


### **2-(6) 모델 학습 과정**
- MLP (최근 성적 지표, Home/away 지표, Vs 지표 제외)

   ![model1](https://user-images.githubusercontent.com/80115212/135569722-7e5ca8a7-a1bd-41a7-b59d-13c4536067f6.PNG)
   * Loss: 0.509
   * Accuracy: 0.748

- MLP (위의 모델에서 지표 추가)

   ![model2](https://user-images.githubusercontent.com/80115212/135569988-6c3a9278-131a-46b3-80e9-7493e13a8301.PNG)
   * Loss: 0.407
   * Accuracy: 0.813

- GRU (Loss function: MSE)

   ![model3](https://user-images.githubusercontent.com/80115212/135570110-c8d4938e-265c-4b0e-9308-bc75d9943edb.PNG)
   * Loss: 0.135
   * Accuracy: 0.816

<br/>

### **2-(7) 모델 성능 비교**
![model_result](https://user-images.githubusercontent.com/80115212/135570773-967891c2-5fe3-4d6b-816c-4ecc77134124.PNG)

<br/>

## **3. 결론**
기존의 지표에 최근 성적 지표, Home/Away 지표, Vs 지표를 추가하여 분류 정확도 5~6% 향상을 이루었고 최종적으로 82%의 정확도를 갖는 딥러닝 모델을 설계하였다.
이를 미루어보아 더욱 방대한 데이터의 수집과 창의적인 지표를 추가한다면 모델의 성능을 더 올릴 수 있을것이라 기대된다.

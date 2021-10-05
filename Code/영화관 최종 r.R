seoul_pop = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 주민등록인구 수.txt", sep="\t",fileEncoding="utf-8")
age_pop = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 연령별 인구.txt", sep="\t",fileEncoding="utf-8")
act_pop = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 서울생활인구 일별.csv", sep=",")
theater = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 영화관.txt", sep="\t",fileEncoding="utf-8")
parking = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 주차장.txt", sep="\t",fileEncoding="utf-8")
road = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 포장도로.txt", sep="\t",fileEncoding="utf-8")
store = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 점포수.txt", sep=" ",fileEncoding="utf-8")
carsharing = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 나눔카 거점리스트.csv", sep=",")
sang_pop = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 상존인구.txt", sep="\t",fileEncoding="utf-8")
price = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 실거래가.csv", sep=",")
grdp = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 GRDP.txt", sep="\t",fileEncoding="utf-8")
hobby = read.csv("C:/Users/Kim Doom/Desktop/응통공모전/구별 취미활동.txt", sep="\t",fileEncoding="utf-8")

# 필요한 변수 추출
library(dplyr)
seoul_pop_tot = seoul_pop[4:28, c(2,4)]
colnames(seoul_pop_tot) = c('자치구', '인구')

act_pop_tot = act_pop[substr(act_pop[, 1], 1, 4)=="2019",c(3, 4)] 
act_pop_tot = act_pop_tot %>% group_by(시군구명) %>% summarise(총생활인구수 = mean(총생활인구수))
act_pop_tot = act_pop_tot[act_pop_tot$시군구명 != '서울시',]
colnames(act_pop_tot) = c('자치구', '생활인구')

theater_tot = theater[2:26, c(2, 5)]
colnames(theater_tot) = c('자치구', '영화관좌석')

parking_tot = parking[4:28, c(2, 4)]
colnames(parking_tot) = c('자치구', '주차장면')

road_tot = road[2:26, c(2, 4)]
colnames(road_tot) = c('자치구', '도로면적')

store_tot = store[2:26, c(1, 2)]
colnames(store_tot) = c('자치구', '점포')

carsharing_tot = carsharing[, c(3, 7)]
carsharing_tot = carsharing_tot %>% group_by(구) %>% summarise(거점수 = n())
colnames(carsharing_tot) = c('자치구', '나눔카거점')

age_pop_tot=as.data.frame(t(age_pop[c(1, 8, 9, 10, 11), seq(5, 77, by=3)]))
rownames(age_pop_tot) = 1:25
colnames(age_pop_tot) = c('자치구', '인구20-24', '인구25-29', '인구30-34', '인구35-39')
age_pop_2024 = age_pop_tot[, c(1, 2)]
age_pop_2529 = age_pop_tot[, c(1, 3)]
age_pop_3034 = age_pop_tot[, c(1, 4)]

sang_pop_road = sang_pop[, c(1, 2)]
colnames(sang_pop_road) = c('자치구', '길단위상존인구')
sang_pop_building = sang_pop[, c(1, 3)]
colnames(sang_pop_building) = c('자치구', '건물단위상존인구')

price_tot = price[, c(3, 4)]
price_tot = price_tot %>% group_by(구) %>% summarise(실거래가 = sum(거래금액.면적.만원.))
colnames(price_tot) = c('자치구', '실거래가')

grdp_tot = grdp[grdp[,3]=='지역내총생산(시장가격)', c(2, 4)]
colnames(grdp_tot) = c('자치구', 'GRDP')

hobby_movie = hobby[28:52, 3:4]
colnames(hobby_movie) = c('자치구', '영상시청')
hobby_culture = hobby[28:52, c(3, 10)]
colnames(hobby_culture) = c('자치구', '문화예술관람')
hobby

# 데이터 병합
all_left_join = function(columns){
  data = left_join(as.data.frame(columns[1:2]), as.data.frame(columns[3:4]), by='자치구')
  for (i in 3:(length(columns)/2)){
    data = left_join(data, as.data.frame(columns[(2*i-1):(2*i)]), by='자치구')
  }
  return(data)
} 

data = all_left_join(c(theater_tot, seoul_pop_tot, act_pop_tot, 
                       parking_tot, road_tot, store_tot, carsharing_tot, 
                       price_tot, sang_pop_road, sang_pop_building, 
                       grdp_tot, hobby_movie, hobby_culture,
                       age_pop_2024, age_pop_2529, age_pop_3034))


# 문자형 변수 중 정수형으로 변환해야 할 변수 변환 
str_to_int = function(data){
  for (i in 2:length(data)){
    data[, i] = as.numeric(gsub(",", "", data[, i]))
  }
  return(data)
}
data = str_to_int(data)


# 연령별 인구 병합
data[, 15] = data[, 15] + data[, 16] + data[, 17]
data = data[, 1:15]
colnames(data)[15] = '인구20.34'


# 분석
# 비선형성 변수 제거
city = data[, 1]
final = data[, 2:length(data)]

plot(final)
final = final[, c(-2, -7, -9, -10, -12, -13)]

final


# 다중공선성 제거
reg = lm(영화관좌석~. , data=final)
library(car)
vif(reg)

final = final[, c(-2, -5)]

reg = lm(영화관좌석~. , data=final)
vif(reg)


# 아웃라이어 제거
reg = lm(영화관좌석~. , data=final)
summary(reg)

par(mfrow=c(1,1))
fitted_value = reg$fitted.values
standardized_residual = rstandard(reg)
plot(fitted_value, standardized_residual)
identify(fitted_value, standardized_residual)

final = final[c(-22), ]


# 변수선택법
plot(final)

reg = lm(영화관좌석~. , data=final)
step(reg, direction = 'both', scope=(~1))

reg = lm(영화관좌석 ~ 도로면적 + 실거래가 , data=final)
summary(reg)

standardized_residual = rstandard(reg)
plot(standardized_residual)
plot(data[, c('영화관좌석', '실거래가', '도로면적')])


# 영화 좌석수 예측값 산출

자치구 = city
영화관좌석 = data[, '영화관좌석']
영화관좌석_추정 = predict(reg, newdata = data[, c('실거래가', '도로면적')])
영화관좌석_차이 = 영화관좌석 - 영화관좌석_추정
result = data.frame(자치구, 영화관좌석, 영화관좌석_추정, 영화관좌석_차이)
result[ order(-result$영화관좌석), ]


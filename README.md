# A piece of python code for data access of the Kyowa-KS2 baniry file

By Dr. ZC Fang (Github: JosephFang)
Copyright 2018

* *ks2 version*: 0
* *csv version*: 0 (old)

## Parent ID and Child ID

### 可変長ヘッダ部全体情報 (`parent id == 1`)

child id

* 4:
* 44
* 45
* 46: Item name
* 47:
* 54
* 55
* 56
* 57
* 58
* 59
* 60
* 61: CAN-ID Info, flgDelta = 2,
* 62: CAN-CH Condition, flgDelta = 4
* 63: CAN通信条件, flgDelta = 2
* 70: CAN-CH条件, flgDelta = 4

### 可変長ヘッダ部個別情報 (`parent id == 2`)

child id

* 2 || 48: valid channel id (2: ks1, 48: ks2), flgCoeff = 3
* 3: coef A, flgCoeff = 1, (KS2 ver01.01~03, float)
* 4: coef B, flgCoeff = 2, (KS2 ver01.01~03, float)
* 67: coef A, flgCoeff = 1, (KS2 ver01.04, double)
* 68: coef B, flgCoeff = 2, (KS2 ver01.04, double)
* 5: unit, flgCoeff = 5;
* 6:
* 8: calibration coefficient, flgCoeff = 7
* 12: offset, flgCoeff = 8
* 48
* 49: channel name, flgCoeff = 4
* 50
* 51: range, flgCoeff = 6
* 52
* 53: low pass filter, flgCoeff = 9
* 54: high pass filter, flgCoeff = 10
* 55

### Data Head (`parent id == 16`)

child id

- 3: start time, flgCoeff = 9
- 29
- 30: number of samples, flgCoeff = 10
- 31:
- 32
- 33
- 34: max/min data, flgDelta = 2 (for ks2ver < 5)
- 35: 400 data samples before and after max/min data, flgDelta = 4
- 36: time point when the max/min data occur

### Data (`parent id == 17`)

child id

- 1; flgDelta = 4
- 2 (and else): flgDelta = 8

## PostData (`parent id == 18`)

child id

- 25: flgDelta = 8
- 26 (and else): flgDelta = 4
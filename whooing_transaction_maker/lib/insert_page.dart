import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget getInsertPage() {
  return Column(

    children: [
      Expanded(flex: 5, child: __upperSection()),
      Column(children: [
        __middleSection(),
        Container(
          height: 300,
          child: __lowerSection(),
        )
      ]),
    ],
  );
}

Widget __upperSection() {
  return Row(
    children: [
      Expanded(
        flex: 6,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(child: Text(entries[index])),
            );
          },
        ),
      ),
      Expanded(
          flex: 4,
          child: Column(
            children: [
              Text('Date',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  )),
              TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter price'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                  )),
              RaisedButton(
                onPressed: () {},
                child: const Text('Button',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          )),
    ],
  );
}

Widget __middleSection() {
  return Row(children: [
    Expanded(
        flex: 5,
        child: Text('Left',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[500],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ))),
    Expanded(
        flex: 5,
        child: Text('Right',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue[500],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ))),
  ]);
}

Widget __lowerSection() {
  return Row(
    children: [
      Expanded(
        flex: 5,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: left.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(child: Text(left[index])),
            );
          },
        ),
      ),
      Expanded(
        flex: 5,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: right.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(child: Text(right[index])),
            );
          },
        ),
      ),
    ],
  );
}



final List entries = [
  '우리ISA',
  '영어수업비',
  '식사',
  '용돈',
  '전자제품',
  '옷',
  '책',
  '병원',
  '주유',
  '우리ISA',
  '영어수업비',
  '식사',
  '용돈',
  '전자제품',
  '옷',
  '책',
  '병원',
  '주유',
  '우리ISA',
  '영어수업비',
  '식사',
  '용돈',
  '전자제품',
  '옷',
  '책',
  '병원',
  '주유',
  '우리ISA',
  '영어수업비',
  '식사',
  '용돈',
  '전자제품',
  '옷',
  '책',
  '병원',
  '주유',
];
final List left = [
  '생활비',
  '식료품',
  '대여료',
  '통신비',
  '의료비',
  '경조사비',
  '선물',
  '용돈',
  '교육비',
  '지식비',
  '레져비',
  '외식비',
  '공과금',
  '생활비',
  '식료품',
  '대여료',
  '통신비',
  '의료비',
  '경조사비',
  '선물',
  '용돈',
  '교육비',
  '지식비',
  '레져비',
  '외식비',
  '공과금',
];
final List right = [
  '우리은행',
  '하나은행',
  '새마을금고',
  '국민은행',
  '삼성증권',
  '신한금융투자',
  '카뱅',
  'SC은행',
  'NH농협',
  '우리은행',
  '하나은행',
  '새마을금고',
  '국민은행',
  '삼성증권',
  '신한금융투자',
  '카뱅',
  'SC은행',
  'NH농협',
  '우리은행',
  '하나은행',
  '새마을금고',
  '국민은행',
  '삼성증권',
  '신한금융투자',
  '카뱅',
  'SC은행',
  'NH농협',
  '우리은행',
  '하나은행',
  '새마을금고',
  '국민은행',
  '삼성증권',
  '신한금융투자',
  '카뱅',
  'SC은행',
  'NH농협',
];

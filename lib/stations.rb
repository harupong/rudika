#!/usr/bin/env ruby
# coding: utf-8

def get_nhk_stations
  {
    "NHK1" => "NHK第1", "NHK2" => "NHK第2", "FM" => "NHK-FM"
  }
end

def get_radiko_stations
  # extracted on Nov. 1st, 2013 from the source html of http://jpradio.herokuapp.com
  {
    "RN1" => "ラジオNIKKEI第1", "RN2" => "ラジオNIKKEI第2", "HOUSOU-DAIGAKU" => "放送大学",
    "HBC" => "ＨＢＣラジオ", "STV" => "ＳＴＶラジオ", "AIR-G" => "AIR-G'（FM北海道） ",
    "IBC" => "IBCラジオ", "TBC" => "TBCラジオ", "RFC" => "RFCラジオ福島",
    "TBS" => "TBSラジオ", "QRR" => "文化放送", "LFR" => "ニッポン放送",
    "INT" => "InterFM", "FMT" => "TOKYO FM", "FMJ" => "J-WAVE",
    "IBS" => "IBS茨城放送", "RADIOBERRY" => "RadioBerry", "FMGUNMA" => "FMぐんま",
    "JORF" => "ラジオ日本 ", "BAYFM78" => "bayfm78", "NACK5" => "NACK5",
    "YFM" => "ＦＭヨコハマ ", "BSN" => "ＢＳＮラジオ ", "FMNIIGATA" => "FM NIIGATA",
    "FMPORT" => "FM PORT", "KNB" => "ＫＮＢラジオ", "FMTOYAMA" => "ＦＭとやま",
    "MRO" => "MRO北陸放送ラジオ", "HELLOFIVE" => "エフエム石川", "FBC" => "FBCラジオ",
    "SBC" => "SBCラジオ", "FMN" => "ＦＭ長野", "CBC" => "CBCラジオ",
    "TOKAIRADIO" => "東海ラジオ", "GBS" => "ぎふチャン", "ZIP-FM" => "ZIP-FM",
    "FMAICHI" => "FM AICHI ", "SBS" => "SBSラジオ", "K-MIX" => "K-MIX SHIZUOKA",
    "FMMIE" => "レディオキューブ ＦＭ三重", "ABC" => "ABCラジオ", "MBS" => "MBSラジオ",
    "OBC" => "OBCラジオ大阪", "CCL" => "FM COCOLO", "802" => "FM802",
    "FMO" => "FM OSAKA", "KISSFMKOBE" => "Kiss FM KOBE", "E-RADIO" => "e-radio FM滋賀",
    "KBS" => "KBS京都ラジオ", "ALPHA-STATION" => "α-STATION FM京都", "CRK" => "CRKラジオ関西",
    "WBS" => "wbs和歌山放送", "BSS" => "BSSラジオ", "RCC" => "中国放送",
    "HFM" => "広島FM", "RNB" => "RNB南海放送", "RKB" => "RKBラジオ",
    "KBC" => "KBCラジオ", "LOVEFM" => "LOVE FM", "FMFUKUOKA" => "FM FUKUOKA",
    "NBC" => "NBC長崎放送", "FMNAGASAKI" => "FM長崎", "RKK" => "RKKラジオ",
    "FMK" => "FMKエフエム熊本", "OBS" => "OBSラジオ", "FM_OITA" => "エフエム大分",
    "MRT" => "宮崎放送", "MBC" => "ＭＢＣラジオ", "RBC" => "RBCiラジオ"
  }
end

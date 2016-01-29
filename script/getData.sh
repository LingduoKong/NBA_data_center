wget http://www.basketballvalue.com/publicdata/AllData2011playoffs20111224.zip
wget http://www.basketballvalue.com/publicdata/AllData20120510040.zip
wget http://www.basketballvalue.com/publicdata/AllData20102011reg20110416.zip
wget http://www.basketballvalue.com/publicdata/AllData2010playoffs20101101.zip
wget http://www.basketballvalue.com/publicdata/AllData20102011reg20110416.zip
wget http://www.basketballvalue.com/publicdata/AllData2010playoffs20101101.zip
wget http://www.basketballvalue.com/publicdata/AllData20092010reg20100418.zip
wget http://www.basketballvalue.com/publicdata/AllData20090614.zip
wget http://www.basketballvalue.com/publicdata/AllData20082009reg20090420.zip
wget http://www.basketballvalue.com/publicdata/AllData2008playoffs20081211.zip
wget http://www.basketballvalue.com/publicdata/AllData20072008reg20081211.zip
wget http://www.basketballvalue.com/publicdata/AllData2007playoffs20081211.zip
wget http://www.basketballvalue.com/publicdata/AllData20070420.zip
ls *.zip|awk -F'.zip' '{print "unzip "$0" -d "$1}'|sh


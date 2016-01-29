mkdir aggregatematchups playerstatsbyteam playerstats players gamelist matchups playbyplay teamstats
for name in AllData*
do
    cd $name
    sed -i '1d' *
    cp aggregatematchups* ../aggregatematchups/
    cp playerstatsbyteam* ../playerstatsbyteam/
    cp playerstats2* ../playerstats/
    cp players2* ../players/
    cp gamelist* ../gamelist/
    cp matchups* ../matchups/
    cp playbyplay* ../playbyplay/
    cp teamstats* ../teamstats/
    cd ../
done

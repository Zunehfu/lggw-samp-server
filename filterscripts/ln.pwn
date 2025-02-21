#include <a_samp>

Float:PlayerScore(kills, deaths, hramp, duelwins, revenges)
{
    new Float:kv;
    
    for(new i = 0; i < kills; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < hramp; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < duelwins; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < revenges; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < deaths; i++) kv -= floatdiv(1, i+1);

    kv = kv/5;
    if(deaths != 0) kv += floatdiv(kills, deaths);
    
    //new Float:result = 0.0;
    //for (new i = 0; i < 10; i++) 
    //{ 
    //    result += (2.0 / (2.0 * i + 1.0)) * floatpower(((kv - 1.0) / (kv + 1.0)), 2.0 * i + 1.0);
    //}
    if(kv > 0) return kv;
    return 0.00;
}

Float:RetScore(kills, deaths, hramp, duelwins, revenges)
{
    new Float:kv;
    
    for(new i = 0; i < kills; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < hramp; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < duelwins; i++) kv += floatdiv(1, i+1);
    for(new i = 0; i < revenges; i++) kv += floatdiv(1, i+1);
    
    kv = kv/6;
    if(deaths != 0) kv += floatdiv(kills, deaths);
    
    new Float:result = 0.0;
    for (new i = 0; i < 10; i++) 
    { 
        result += (2.0 / (2.0 * i + 1.0)) * floatpower(((kv - 1.0) / (kv + 1.0)), 2.0 * i + 1.0);
    }
    return result;
}



/*
// 1st algorithm
kills - 913 | deaths - 998 | highest ramp - 79 | duels won - 344 | revenges - 20 === score - 4.642253
kills - 703 | deaths - 262 | highest ramp - 85 | duels won - 295 | revenges - 75 === score - 6.570919
kills - 722 | deaths - 377 | highest ramp - 81 | duels won - 144 | revenges - 49 === score - 5.609698
kills - 238 | deaths - 764 | highest ramp - 13 | duels won - 297 | revenges - 55 === score - 3.661180
kills - 804 | deaths - 193 | highest ramp - 43 | duels won - 54 | revenges - 64 === score - 7.655262
kills - 25 | deaths - 884 | highest ramp - 44 | duels won - 270 | revenges - 11 === score - 2.925955
kills - 359 | deaths - 544 | highest ramp - 73 | duels won - 5 | revenges - 36 === score - 3.625649
kills - 127 | deaths - 811 | highest ramp - 92 | duels won - 263 | revenges - 37 === score - 3.637035
kills - 932 | deaths - 526 | highest ramp - 60 | duels won - 3 | revenges - 74 === score - 4.907916
kills - 158 | deaths - 686 | highest ramp - 88 | duels won - 175 | revenges - 51 === score - 3.724798
kills - 771 | deaths - 783 | highest ramp - 3 | duels won - 200 | revenges - 77 === score - 4.295412
kills - 571 | deaths - 78 | highest ramp - 65 | duels won - 42 | revenges - 26 === score - 10.631499
kills - 869 | deaths - 258 | highest ramp - 93 | duels won - 330 | revenges - 77 === score - 7.329160
kills - 759 | deaths - 496 | highest ramp - 3 | duels won - 280 | revenges - 75 === score - 4.889968
kills - 89 | deaths - 144 | highest ramp - 46 | duels won - 330 | revenges - 4 === score - 3.609606

// 2nd algorithm
kills - 582 | deaths - 864 | highest ramp - 49 | duels won - 371 | revenges - 1 === score - 1.342000
kills - 562 | deaths - 581 | highest ramp - 65 | duels won - 350 | revenges - 61 === score - 1.561820
kills - 872 | deaths - 586 | highest ramp - 1 | duels won - 342 | revenges - 27 === score - 1.525384
kills - 674 | deaths - 315 | highest ramp - 67 | duels won - 360 | revenges - 32 === score - 1.770345
kills - 125 | deaths - 51 | highest ramp - 10 | duels won - 232 | revenges - 66 === score - 1.729936
kills - 730 | deaths - 798 | highest ramp - 53 | duels won - 123 | revenges - 75 === score - 1.522827
kills - 845 | deaths - 972 | highest ramp - 35 | duels won - 276 | revenges - 60 === score - 1.524566
kills - 745 | deaths - 871 | highest ramp - 74 | duels won - 146 | revenges - 10 === score - 1.454901
kills - 756 | deaths - 706 | highest ramp - 44 | duels won - 278 | revenges - 35 === score - 1.553095
kills - 379 | deaths - 586 | highest ramp - 63 | duels won - 190 | revenges - 1 === score - 1.297086
kills - 417 | deaths - 970 | highest ramp - 31 | duels won - 195 | revenges - 32 === score - 1.349343
kills - 491 | deaths - 548 | highest ramp - 39 | duels won - 355 | revenges - 23 === score - 1.488734
kills - 341 | deaths - 906 | highest ramp - 96 | duels won - 225 | revenges - 9 === score - 1.327962
kills - 410 | deaths - 470 | highest ramp - 0 | duels won - 35 | revenges - 71 === score - 1.244266
kills - 295 | deaths - 92 | highest ramp - 93 | duels won - 269 | revenges - 57 === score - 1.931649
*/
public OnFilterScriptInit()
{
	for(new i = 0; i < 15; i++)
	{
		new k = random(5000), d = random(1000), hr = random(256), dw = random(800), rev = random(200);
		printf("kills - %d | deaths - %d | highest ramp - %d | duels won - %d | revenges - %d === score - %f", k, d, hr, dw, rev, PlayerScore(k, d, hr, dw, rev));
	}
	return 1;
}

10
10
10
10
10
10
10
10
/*[08:07:19] kills - 7496 | deaths - 961 | highest ramp - 199 | duels won - 233 | revenges - 9 === score - 13.858164
[08:07:19] kills - 6510 | deaths - 208 | highest ramp - 211 | duels won - 724 | revenges - 120 === score - 38.253429
[08:07:19] kills - 3326 | deaths - 132 | highest ramp - 82 | duels won - 457 | revenges - 30 === score - 31.290695
[08:07:19] kills - 8932 | deaths - 816 | highest ramp - 242 | duels won - 230 | revenges - 103 === score - 17.690372
[08:07:19] kills - 1585 | deaths - 31 | highest ramp - 90 | duels won - 470 | revenges - 83 === score - 57.319416
[08:07:19] kills - 14028 | deaths - 828 | highest ramp - 99 | duels won - 225 | revenges - 106 === score - 23.578121
[08:07:19] kills - 4637 | deaths - 134 | highest ramp - 147 | duels won - 783 | revenges - 29 === score - 41.052684
[08:07:19] kills - 9537 | deaths - 416 | highest ramp - 249 | duels won - 532 | revenges - 102 === score - 29.900173
[08:07:19] kills - 14959 | deaths - 177 | highest ramp - 70 | duels won - 452 | revenges - 152 === score - 91.344009
[08:07:19] kills - 3319 | deaths - 577 | highest ramp - 212 | duels won - 525 | revenges - 145 === score - 12.507144
[08:07:19] kills - 5094 | deaths - 438 | highest ramp - 143 | duels won - 563 | revenges - 137 === score - 18.397369
[08:07:19] kills - 4249 | deaths - 571 | highest ramp - 45 | duels won - 585 | revenges - 87 === score - 13.772649
[08:07:19] kills - 14593 | deaths - 255 | highest ramp - 37 | duels won - 501 | revenges - 64 === score - 63.703914
[08:07:19] kills - 10765 | deaths - 533 | highest ramp - 99 | duels won - 619 | revenges - 115 === score - 27.039833
[08:07:19] kills - 6700 | deaths - 536 | highest ramp - 58 | duels won - 679 | revenges - 38 === score - 18.839975
*/
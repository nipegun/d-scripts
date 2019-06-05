#!/bin/bash
set -e
IFS=$'\n\t'

# Version 1.01; August 2016
# Copyright (c) 2016 Patrick Vessey <patrick@linuxluddites.com>
# This software is released under the MIT License; for further information,
# please refer to <https://opensource.org/licenses/MIT>

# Filter Apache-style web logs in accordance with the criteria defined by
# the Public Radio Podcast Measurement Guidelines version 1.1; for further
# information, refer to <https://github.com/PatrickVessey/prpm-filter>

REGEX=${1:-}
if [[ -z "$REGEX" ]]; then
    echo "usage: $0 \"POSIX regex for media file URLs\"" >&2
    echo "e.g. cat access.log | $0 \"\/shows\/Episode[[:digit]]{1,3}\.(mp3|ogg)$\" | ..." >&2
    exit 1
fi

# Build a regex-safe string containg a list of bots/crawlers
BOTS=$(wget -qO- -t 5 -T 5 http://www.useragentstring.com/pages/useragentstring.php?typ=Crawler \
    | tr -d '\n' | sed -e "s/<img[^>]*>//g" | tr '<' '\n' | grep '^h3>' \
    | cut -c4- | tr '\n' '|' | tr -c '[[:alnum:]]|\|' '.' | sed s'/.$//')
if [[ -z "$BOTS" ]]; then
	echo "warning: useragentstring.com unreachable, using fallback list of bots" >&2
	BOTS="008|ABACHOBot|Accoona.AI.Agent|AddSugarSpiderBot|AnyApexBot|Arachmo|B.l.i.t.z.B.O.T|Baiduspider|BecomeBot|BeslistBot|BillyBobBot|Bimbot|Bingbot|BlitzBOT|boitho.com.dc|boitho.com.robot|btbot|CatchBot|Cerberian.Drtrs|Charlotte|ConveraCrawler|cosmos|Covario.IDS|DataparkSearch|DiamondBot|Discobot|Dotbot|EmeraldShield.com.WebBot|envolk[ITS]spider|EsperanzaBot|Exabot|FAST.Enterprise.Crawler|FAST.WebCrawler|FDSE.robot|FindLinks|FurlBot|FyberSpider|g2crawler|Gaisbot|GalaxyBot|genieBot|Gigabot|Girafabot|Googlebot|Googlebot.Image|GurujiBot|HappyFunBot|hl.ftien.spider|Holmes|htdig|iaskspider|ia.archiver|iCCrawler|ichiro|igdeSpyder|IRLbot|IssueCrawler|Jaxified.Bot|Jyxobot|KoepaBot|L.webis|LapozzBot|Larbin|LDSpider|LexxeBot|Linguee.Bot|LinkWalker|lmspider|lwp.trivial|mabontland|magpie.crawler|Mediapartners.Google|MJ12bot|Mnogosearch|mogimogi|MojeekBot|Moreoverbot|Morning.Paper|msnbot|MSRBot|MVAClient|mxbot|NetResearchServer|NetSeer.Crawler|NewsGator|NG.Search|nicebot|noxtrumbot|Nusearch.Spider|NutchCVS|Nymesis|obot|oegp|omgilibot|OmniExplorer.Bot|OOZBOT|Orbiter|PageBitesHyperBot|Peew|polybot|Pompos|PostPost|Psbot|PycURL|Qseero|Radian6|RAMPyBot|RufusBot|SandCrawler|SBIder|ScoutJet|Scrubby|SearchSight|Seekbot|semanticdiscovery|Sensis.Web.Crawler|SEOChat..Bot|SeznamBot|Shim.Crawler|ShopWiki|Shoula.robot|silk|Sitebot|Snappy|sogou.spider|Sosospider|Speedy.Spider|Sqworm|StackRambler|suggybot|SurveyBot|SynooBot|Teoma|TerrawizBot|TheSuBot|Thumbnail.CZ.robot|TinEye|truwoGPS|TurnitinBot|TweetedTimes.Bot|TwengaBot|updated|Urlfilebot|Vagabondo|VoilaBot|Vortex|voyager|VYU2|webcollage|Websquash.com|wf84|WoFindeIch.Robot|WomlpeFactory|Xaldon.WebSpider|yacy|Yahoo..Slurp|Yahoo..Slurp.China|YahooSeeker|YahooSeeker.Testing|YandexBot|YandexImages|Yasaklibot|Yeti|YodaoBot|yoogliFetchAgent|YoudaoBot|Zao|Zealbot|zspider|ZyBorg"
fi

gawk -P 'BEGIN {
        FS="( \"|\" )"
        OFS="\t"
        split("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", m, ",")
        for(i in m)
            month[m[i]]=sprintf("%02d", i)
    }
    {
        split($1, a, " ")
        ip=a[1]
        dd=substr(a[4], 2, 2)
        mm=month[substr(a[4], 5, 3)]
        yyyy=substr(a[4], 9, 4)
        split($2, b, " ")
        type=b[1]
        url=b[2]
        split($3, c, " ")
        status=c[1]
        served=c[2]
        ua=substr($5, 2)
        range=$6
        gsub("\"", "", range)
        sub("bytes=", "", range)
        if(type!="GET")
            next
        if(url !~ /'$REGEX'/)
            next
        if(status !~ /^20[0,6]$/)
            next
        if((status=="206") && (range && (range !~ /^(0-.*|-)$/)))
            next
        if(ua ~ /'$BOTS'/)
            next
        if(served<=200000)
            next
        # Uncomment to strip path from show filename, if desired
        #gsub(".*/", "", url)
        # Uncomment to strip query string from show filename, if desired
        #gsub("\\?.*$", "", url)
        print url, yyyy"-"mm"-"dd, ip, ua
    }' | sort -u
#eof

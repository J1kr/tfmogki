resource "aws_route53_zone" "mogki_com" {
	name = "mogki.com"
    comment = "R53 Migration Terrform"
}

resource "aws_route53_record" "mogki_com_mx" {
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "mogki.com"
  type    = "MX"
  ttl     = "1800"
  records = [
    "10 inbound-smtp.us-east-1.amazonaws.com" ,
  ]
}

resource "aws_route53_record" "mogki_com_a" {
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "mogki.com"
  type    = "A"
  ttl     = "1800"
  records = [aws_instance.J1-tenv.public_ip]
}

resource "aws_route53_record" "mogki_com_ns" {
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "mogki.com"
  type    = "NS"
  ttl     = "1800"
  records = ["ns-604.awsdns-11.net.",
  "ns-1109.awsdns-10.org.",
  "ns-12.awsdns-01.com.",
  "ns-1678.awsdns-17.co.uk.",
  ]
}

resource "aws_route53_record" "mogki_com_soa" {
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "mogki.com"
  type    = "SOA"
  ttl     = "1800"
  records = ["ns-604.awsdns-11.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
}

resource "aws_route53_record" "mogki_com_txt_ses" {
  zone_id = aws_route53_zone.mogki_com.zone_id
  name    = "_amazonses.mogki.com"
  type    = "TXT"
  ttl     = "1800"
  records = ["8aJROk4tvg+zRo1qeLSDvRhS4ylA2XxMjSLoarDV0L0="]
}
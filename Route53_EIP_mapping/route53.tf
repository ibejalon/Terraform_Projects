resource "aws_route53_zone" "az-route" {
  name = "azkube.space"
}

resource "aws_route53_record" "az-Route" {
  zone_id = aws_route53_zone.az-route.zone_id
  name    = "server1.azkube.space"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.server1.public_ip}"]
}

resource "aws_route53_record" "www-record" {
  zone_id = aws_route53_zone.az-route.zone_id
  name    = "www.azkube.space"
  type    = "A"
  ttl     = "300"
  records = ["104.236.247.8"]
}

resource "aws_route53_record" "mail1-record" {
  zone_id = aws_route53_zone.az-route.zone_id
  name    = "azkube.space"
  type    = "MX"
  ttl     = "300"
  records = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 aspmx2.googlemail.com.",
    "10 aspmx3.googlemail.com.",
  ]
}

output "ns-servers" {
  value = aws_route53_zone.az-route.name_servers
}


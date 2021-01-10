ALBのリスナーとしてlambdaを利用する
==============================

ALBのターゲットグループとしてlambdaを利用する．

注意点としては，LBのターゲットグループに1つのlambdaしかターゲットタイプを登録できない
(1つの aws_lb_target_group に対して1つの aws_lb_target_group_attachment)．
lambdaなら負荷分散などは不要なのでこれは当然．

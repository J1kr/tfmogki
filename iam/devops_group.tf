resource "aws_iam_group" "devops_group" {
  name = "devops"
}

resource "aws_iam_group_membership" "devops" {
  name = aws_iam_group.devops_group.name
  users = [
      aws_iam_user.J1_Terrafrom.name
  ]  
  group = aws_iam_group.devops_group.name
}
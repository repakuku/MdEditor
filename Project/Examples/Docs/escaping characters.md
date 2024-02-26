# Экранирование (escaping characters)

Многие символы в Markdown выполняют роль служебных. Если они встречаются в вашем тексте сами по себе, то для корректного отображения их стоит экранировать (иначе они просто не только не отобразятся сами, но и добавят вашему тексту какое-нибудь ненужное форматирование). Для этого перед ними ставится обратная косая черта \.

Вот список символов, которые нужно экранировать: \`*_{}[]<>()#+-.! |. Делать это постоянно необязательно — достаточно ставить экран только в тех случаях, когда Markdown может воспринять эти символы как служебные. Например, если строка начинается с символа #, то экранировать её надо — потому что программа может решить, что вы хотите сделать заголовок. А вот если решётка находится где-то в центре строки, то экранировать ничего не надо — редактор поймёт, что тут она просто часть текста.
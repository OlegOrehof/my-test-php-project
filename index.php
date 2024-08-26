<?php
// Получение данных из запроса
$name = $_GET['name'] ?? 'Anonymous';

// Генерация динамического содержимого
$html = <<<HTML
<html>
  <head>
    <title>Привет, $name!</title>
  </head>
  <body>
    <h1>Здравствуйте, $name!</h1>
    <p>Это динамическая веб-страница, обработанная PHP.</p>
  </body>
</html>
HTML;

// Отправка ответа обратно в NGINX
echo $html;

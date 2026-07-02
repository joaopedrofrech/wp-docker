<?php

declare(strict_types=1);

if (is_file(__DIR__ . "/login-password-less.php")) {
    function adminer_object(): Adminer\Plugins
    {
        $pluginFile = __DIR__ . "/login-password-less.php";
        if (!is_file($pluginFile) || filesize($pluginFile) === 0) {
            return new Adminer\Plugins([]);
        }

        require_once $pluginFile;
        if (!class_exists("AdminerLoginPasswordLess", false)) {
            return new Adminer\Plugins([]);
        }

        $password = getenv("ADMINER_LOGIN_PASSWORD");
        if ($password === false || $password === "") {
            $password = bin2hex(random_bytes(32));
        }

        return new Adminer\Plugins([
            new AdminerLoginPasswordLess(
                password_hash($password, PASSWORD_DEFAULT),
            ),
        ]);
    }
}

require __DIR__ . "/adminer.php";

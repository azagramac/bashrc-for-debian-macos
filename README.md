## Capturas de pantalla

| Terminal MacOS | Terminal Linux |
|----------------|----------------|
| <img src="https://github.com/user-attachments/assets/f2811984-7045-4f10-a897-402797246f00" width="600"/> <br> `.bash_profile` | <img src="https://github.com/user-attachments/assets/cfacbf2a-36a8-4a94-9f66-abc3fb2adcf6" width="650"/> <br> `.bashrc` |

---

## Aplicar la configuración

### 🐧 Linux

1. Copia el archivo `.bashrc` a tu home `/home/$USER/`:

```bash
cp .bashrc ~/
```

2. Recarga la configuración sin cerrar la terminal:

```bash
source ~/.bashrc
```

---

### 🍎 MacOS

1. Cambiar la shell por defecto a Bash

```bash
chsh -s /bin/bash
```
> Esto cambiará tu shell de login a bash.
> Debes cerrar la sesión y volver a abrirla (o reiniciar la terminal) para que tenga efecto.

2. Copia el archivo `.bash_profile` a tu home `/Users/$USER/`:

```bash
cp .bash_profile ~/
```

3. Recarga la configuración sin cerrar la terminal:

```bash
source ~/.bash_profile
```

4. Para eliminar el mensaje `Last login:` al abrir la terminal (opcional):

```bash
touch ~/.hushlogin
```

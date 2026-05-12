from tkinter import END, Button, Entry, Tk

from calculadora import Calculadora


class Interfaz:
    def __init__(self, root: Tk):
        self.root = root
        self.root.title("Calculadora")
        self.root.configure(bg="#2B2B2B")
        self.root.resizable(False, False)
        self.calc = Calculadora()
        self._construir_widgets()

    def _construir_widgets(self):
        estilo_entrada = {
            "font": ("Consolas", 28),
            "justify": "right",
            "bd": 0,
            "bg": "#1E1E1E",
            "fg": "#FFFFFF",
            "insertbackground": "#FFFFFF",
        }
        self.entrada = Entry(self.root, **estilo_entrada)
        self.entrada.grid(
            row=0, column=0, columnspan=4, ipadx=10, ipady=18, padx=10, pady=(18, 10)
        )

        numeros = [
            ("7", 1, 0),
            ("8", 1, 1),
            ("9", 1, 2),
            ("4", 2, 0),
            ("5", 2, 1),
            ("6", 2, 2),
            ("1", 3, 0),
            ("2", 3, 1),
            ("3", 3, 2),
            ("0", 4, 0),
            (".", 4, 1),
            ("C", 4, 2),
        ]
        operadores = [
            ("/", 1, 3),
            ("*", 2, 3),
            ("-", 3, 3),
            ("+", 4, 3),
        ]

        for texto, fila, col in numeros:
            self._crear_boton(texto, fila, col, sombra=False)

        for texto, fila, col in operadores:
            self._crear_boton(texto, fila, col, operador=True)

        estilo_igual = {
            "text": "=",
            "font": ("Arial", 18, "bold"),
            "width": 33,
            "height": 2,
            "bg": "#FFA500",
            "fg": "#1E1E1E",
            "activebackground": "#E69500",
            "activeforeground": "#1E1E1E",
            "relief": "flat",
            "cursor": "hand2",
            "command": self._calcular,
        }
        Button(self.root, **estilo_igual).grid(
            row=5, column=0, columnspan=4, padx=10, pady=(8, 16)
        )

    def _crear_boton(
        self,
        texto: str,
        fila: int,
        col: int,
        operador: bool = False,
        sombra: bool = True,
    ):
        if operador:
            estilo = {
                "text": texto,
                "font": ("Arial", 18, "bold"),
                "width": 5,
                "height": 2,
                # Para que sus bordes sean redondos
                "bg": "#FFA500",
                "fg": "#1E1E1E",
                "activebackground": "#E69500",
                "activeforeground": "#1E1E1E",
                "relief": "flat",
                "cursor": "hand2",
            }
        elif texto == "C":
            estilo = {
                "text": texto,
                "font": ("Arial", 16, "bold"),
                "width": 5,
                "height": 2,
                "bg": "#D32F2F",
                "fg": "#FFFFFF",
                "activebackground": "#B71C1C",
                "activeforeground": "#FFFFFF",
                "relief": "flat",
                "cursor": "hand2",
            }
        else:
            estilo = {
                "text": texto,
                "font": ("Arial", 18, "bold"),
                "width": 5,
                "height": 2,
                "bg": "#3C3C3C",
                "fg": "#FFFFFF",
                "activebackground": "#505050",
                "activeforeground": "#FFFFFF",
                "relief": "flat",
                "cursor": "hand2",
            }

        def cmd(t=texto):
            self._on_boton(t)

        estilo["command"] = cmd

        btn = Button(self.root, **estilo)
        btn.grid(row=fila, column=col, padx=3, pady=3)
        return btn

    def _on_boton(self, texto: str):
        if texto == "C":
            self.entrada.delete(0, END)
        else:
            self.entrada.insert(END, texto)

    def _calcular(self):
        expresion = self.entrada.get()
        try:
            resultado = eval(expresion)
            self.entrada.delete(0, END)
            self.entrada.insert(END, str(resultado))
        except ZeroDivisionError:
            self.entrada.delete(0, END)
            self.entrada.insert(END, "Error: div / 0")
        except Exception:
            self.entrada.delete(0, END)
            self.entrada.insert(END, "Error")


def main():
    root = Tk()
    Interfaz(root)
    root.mainloop()


if __name__ == "__main__":
    main()

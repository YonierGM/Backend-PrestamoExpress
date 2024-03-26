from datetime import date
from typing import Optional
from pydantic import BaseModel

class Cliente(BaseModel):
    clienteid: Optional[int]
    nombre: str
    apellido: str
    documento: int
    email: str
    celular: str
    profesion: str
    ingresosMensuales: int
    contrasena: str
    rolid: int

from fastapi import APIRouter, HTTPException, Response, status
from typing import List
from sqlalchemy import insert

from config.db import conn
from models.usuario import usuarios
from schemas.usuario import Usuario

#para encriptar la contraseña
from bcrypt import hashpw, gensalt

usuarioRoutes = APIRouter()

from fastapi import HTTPException, status
from pydantic import BaseModel

@usuarioRoutes.post("/login", tags=["usuarios"], description="Login and verify user credentials")
def login(usuario: Usuario):
    # Verificar si existe el usuario
    existing_usuario = conn.execute(usuarios.select().where(usuarios.c.username == usuario.username)).first()
    if existing_usuario:
        # Verificar la contraseña
        if existing_usuario.passw == usuario.passw:
            # Verificar el rol
            if existing_usuario.rolid == usuario.rolid:
                return {"message": "Login successful", "rol": existing_usuario.rolid}
            else:
                raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Unauthorized access: Incorrect role")
        else:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized access: Incorrect password")
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")


# Obtener todos los usuarios
@usuarioRoutes.get("/usuarios", tags=["usuarios"], response_model=List[Usuario], description="Get a list of all users")
def get_usuarios():
    return conn.execute(usuarios.select()).fetchall()

# Obtener un usuario por su ID
@usuarioRoutes.get("/usuarios/{id}", tags=["usuarios"], response_model=Usuario, description="Get a single user by ID")
def get_usuario(id: int):
    existing_usuario = conn.execute(usuarios.select().where(usuarios.c.usuarioid == id)).first()
    if existing_usuario:
        return existing_usuario
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")

# Crear un nuevo usuario
@usuarioRoutes.post("/usuarios", tags=["usuarios"], response_model=Usuario, description="Create a new user")
def create_usuario(usuario: Usuario):
    try:
        # Encriptar la contraseña antes de almacenarla
        hashed_password = hashpw(usuario.passw.encode('utf-8'), gensalt())

        new_usuario = {"username": usuario.username, "passw": hashed_password, "rolid": usuario.rolid}
        result = conn.execute(insert(usuarios).values(new_usuario))
        new_usuario["usuarioid"] = result.inserted_primary_key[0]
        conn.commit()

        return new_usuario
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# Actualizar un usuario por su ID
@usuarioRoutes.put("/usuarios/{id}", tags=["usuarios"], response_model=Usuario, description="Update a user by ID")
def update_usuario(id: int, usuario: Usuario):
    existing_usuario = conn.execute(usuarios.select().where(usuarios.c.usuarioid == id)).fetchone()
    if existing_usuario:
        # Encriptar la contraseña antes de almacenarla
        hashed_password = hashpw(usuario.passw.encode('utf-8'), gensalt())

        conn.execute(
            usuarios.update()
            .values(username=usuario.username, passw= hashed_password, rolid=usuario.rolid)
            .where(usuarios.c.usuarioid == id)
        )
        conn.commit()
        return Response(status_code=status.HTTP_200_OK, content="Usuario actualizado")
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")

# Eliminar un usuario por su ID
@usuarioRoutes.delete("/usuarios/{id}", tags=["usuarios"])
def delete_usuario(id: int):
    existing_usuario = conn.execute(usuarios.select().where(usuarios.c.usuarioid == id)).fetchone()
    if existing_usuario:
        conn.execute(usuarios.delete().where(usuarios.c.usuarioid == id))
        conn.commit()
        return status.HTTP_200_OK
    else:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")

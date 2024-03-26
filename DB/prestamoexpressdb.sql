-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.administradores
(
    administradorid serial NOT NULL,
    nombre character varying(255) COLLATE pg_catalog."default",
    apellido character varying(255) COLLATE pg_catalog."default",
    documento integer,
    email character varying(255) COLLATE pg_catalog."default",
    celular character varying(255) COLLATE pg_catalog."default",
    rolid integer,
    CONSTRAINT administradores_pkey PRIMARY KEY (administradorid)
);

CREATE TABLE IF NOT EXISTS public.clientes
(
    clienteid serial NOT NULL,
    nombre character varying(255) COLLATE pg_catalog."default",
    apellido character varying(255) COLLATE pg_catalog."default",
    documento integer,
    fecha_nac date,
    direccion character varying(255) COLLATE pg_catalog."default",
    celular character varying(255) COLLATE pg_catalog."default",
    email character varying(255) COLLATE pg_catalog."default",
    rolid integer,
    CONSTRAINT clientes_pkey PRIMARY KEY (clienteid)
);

CREATE TABLE IF NOT EXISTS public.estadoprestamos
(
    estadoid serial NOT NULL,
    descripcion character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT estadoprestamos_pkey PRIMARY KEY (estadoid)
);

CREATE TABLE IF NOT EXISTS public.pagos
(
    pagoid serial NOT NULL,
    fechapago date,
    monto integer,
    prestamoid integer,
    CONSTRAINT pagos_pkey PRIMARY KEY (pagoid)
);

CREATE TABLE IF NOT EXISTS public.prestamos
(
    prestamoid serial NOT NULL,
    fechaprestamo date,
    fechaestimadapago date,
    monto integer,
    cuotas integer,
    valorcuota integer,
    clienteid integer,
    estadoid integer,
    tipoprestamoid integer,
    CONSTRAINT prestamos_pkey PRIMARY KEY (prestamoid)
);

CREATE TABLE IF NOT EXISTS public.roles
(
    rolid serial NOT NULL,
    descripcion character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT roles_pkey PRIMARY KEY (rolid)
);

CREATE TABLE IF NOT EXISTS public.tipoprestamos
(
    tipoprestamoid serial NOT NULL,
    descripcion character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT tipoprestamos_pkey PRIMARY KEY (tipoprestamoid)
);

CREATE TABLE IF NOT EXISTS public.usuarios
(
    usuarioid serial NOT NULL,
    username character varying(255) COLLATE pg_catalog."default",
    passw character varying(255) COLLATE pg_catalog."default",
    rolid integer,
    CONSTRAINT usuarios_pkey PRIMARY KEY (usuarioid)
);

ALTER TABLE IF EXISTS public.administradores
    ADD CONSTRAINT administradores_rolid_fkey FOREIGN KEY (rolid)
    REFERENCES public.roles (rolid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.clientes
    ADD CONSTRAINT clientes_rolid_fkey FOREIGN KEY (rolid)
    REFERENCES public.roles (rolid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.pagos
    ADD CONSTRAINT pagos_prestamoid_fkey FOREIGN KEY (prestamoid)
    REFERENCES public.prestamos (prestamoid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.prestamos
    ADD CONSTRAINT prestamos_clienteid_fkey FOREIGN KEY (clienteid)
    REFERENCES public.clientes (clienteid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.prestamos
    ADD CONSTRAINT prestamos_estadoid_fkey FOREIGN KEY (estadoid)
    REFERENCES public.estadoprestamos (estadoid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.prestamos
    ADD CONSTRAINT prestamos_tipoprestamoid_fkey FOREIGN KEY (tipoprestamoid)
    REFERENCES public.tipoprestamos (tipoprestamoid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.usuarios
    ADD CONSTRAINT usuarios_rolid_fkey FOREIGN KEY (rolid)
    REFERENCES public.roles (rolid) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


---Inserts-----------------------

-- Roles
INSERT INTO public.roles (descripcion)
VALUES ('Cliente'),
       ('Administrador');

-- Tipo de Préstamos
INSERT INTO public.tipoprestamos (descripcion)
VALUES ('Bronze'),
       ('Platino'),
		('Gold');

-- Usuarios
INSERT INTO public.usuarios (username, passw, rolid)
VALUES ('admin', 'admin123', 2),
       ('cliente1', 'cliente123', 1),
       ('cliente2', 'cliente456', 1);

-- Administradores
INSERT INTO public.administradores (nombre, apellido, documento, email, celular, rolid)
VALUES ('Juan', 'Perez', 123456789, 'juan@example.com', '123456789', 1),
       ('María', 'Gomez', 987654321, 'maria@example.com', '987654321', 1),
       ('Pedro', 'Lopez', 456789123, 'pedro@example.com', '456789123', 1);

-- Estado de Préstamos
INSERT INTO public.estadoprestamos (descripcion)
VALUES ('Pendiente'),
       ('Al dia'),
		('Pagado'),
		('Retrazo'),
       ('Mora');

-- Clientes
INSERT INTO public.clientes (nombre, apellido, documento, fecha_nac, direccion, celular, email, rolid)
VALUES ('Carlos', 'Martinez', 234567890, '1990-05-15', 'Calle 123', '234567890', 'carlos@example.com', 2),
       ('Laura', 'Rodriguez', 345678901, '1992-10-20', 'Avenida 456', '345678901', 'laura@example.com', 2),
       ('Andres', 'Garcia', 456789012, '1985-03-10', 'Carrera 789', '456789012', 'andres@example.com', 2);


-- Préstamos
INSERT INTO public.prestamos (fechaprestamo, fechaestimadapago, monto, cuotas, valorcuota, clienteid, estadoid, tipoprestamoid)
VALUES ('2023-01-01', '2023-07-01', 1000000, 5, 200000, 1, 1, 1),
       ('2023-02-01', '2023-08-01', 2000000, 2, 1000000, 2, 1, 1),
       ('2023-03-01', '2023-09-01', 500000, 2, 250000, 3, 1, 2);

END;
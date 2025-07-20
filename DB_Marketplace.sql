use master
go 
create database Medilink
	ON PRIMARY
		(name = Medilink,
		 filename = 'C:\BD\ Medilink.mdf',
		 size=20, maxsize=unlimited, filegrowth=10%)
	LOG ON
		(name = Medilink,
		 filename = 'C:\BD\ Medilink.idf',
		 size=50)
go
use MarketPlaceMedicos;
go

-- PERSONA
CREATE TABLE Persona (
    Cedula VARCHAR(9) NOT NULL,
    Nombre1 VARCHAR(30) NOT NULL,
    Nombre2 VARCHAR(30),
    Ap1 VARCHAR(30) NOT NULL,
    Ap2 VARCHAR(30) NOT NULL,
    Sexo VARCHAR(10) NOT NULL, -- 'Masculino', 'Femenino', 'Otro'
    FechaNacimiento DATE NOT NULL,
    CONSTRAINT PK_Persona PRIMARY KEY (Cedula)
);


-- PACIENTE
CREATE TABLE Paciente(
    IdPaciente INT IDENTITY(1,1) NOT NULL,
    CedulaId VARCHAR(9) NOT NULL,
	GrupoSanguineo VARCHAR(3) CHECK (GrupoSanguineo IN (
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')) NOT NULL,
    EstadoPaciente BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Paciente PRIMARY KEY (IdPaciente),
    CONSTRAINT FK_Paciente_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


--EXPEDIENTE
CREATE TABLE Expediente (
    IdExpediente INT IDENTITY(1,1) NOT NULL,
    PacienteId INT NOT NULL,
	Alergias VARCHAR(100) NOT NULL,
    FechaCreacion DATE DEFAULT GETDATE(),
    ObservacionesGenerales TEXT,
	EstadoExpediente BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Expediente PRIMARY KEY (IdExpediente),
    CONSTRAINT FK_Expediente_Paciente FOREIGN KEY (PacienteId) REFERENCES Paciente(IdPaciente),
);


--EXAMEN RADIOLOGICO
CREATE TABLE ExamenRadiologico (
    IdExamenRad INT IDENTITY(1,1) NOT NULL,
    ExpedienteId INT NOT NULL,
    FechaExamen DATE NOT NULL,
    TipoImagen VARCHAR(100) NOT NULL,
    InformeRadiologico TEXT,
	URLImagen VARCHAR(255),
    CONSTRAINT PK_ExamenRadiologico PRIMARY KEY (IdExamenRad),
    CONSTRAINT FK_ExamenRad_Expediente FOREIGN KEY (ExpedienteId) REFERENCES Expediente(IdExpediente)
);


--EXAMEN LABORATORIO
CREATE TABLE ExamenLaboratorio (
    IdExamenLab INT IDENTITY(1,1) NOT NULL,
    ExpedienteId INT NOT NULL,
    FechaLaboratorio DATE NOT NULL,
    TipoAnalisis VARCHAR(100) NOT NULL,
    ResultadoAnalisis TEXT,
    CONSTRAINT PK_ExamenLaboratorio PRIMARY KEY (IdExamenLab),
    CONSTRAINT FK_ExamenLab_Expediente FOREIGN KEY (ExpedienteId) REFERENCES Expediente(IdExpediente)
);


--EXAMEN OPERACION
CREATE TABLE Operacion (
    IdOperacion INT IDENTITY(1,1) NOT NULL,
    ExpedienteId INT NOT NULL,
    FechaOperacion DATE NOT NULL,
    NombreOperacion VARCHAR(100) NOT NULL,
    DescripcionOperacion TEXT,
    CONSTRAINT PK_Operacion PRIMARY KEY (IdOperacion),
    CONSTRAINT FK_Operacion_Expediente FOREIGN KEY (ExpedienteId) REFERENCES Expediente(IdExpediente),
);


-- ESPECIALIDAD
CREATE TABLE Especialidad (
    IdEspecialidad INT IDENTITY(1,1) NOT NULL,
    NombreEspecialidad VARCHAR(50) NOT NULL,
    DescripcionEspecialidad TEXT,
    EstadoEspecialidad BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Especialidad PRIMARY KEY (IdEspecialidad)
);


-- MEDICO
CREATE TABLE Medico (
    IdMedico INT IDENTITY(1,1) NOT NULL,
    CedulaId VARCHAR(9) NOT NULL,
    EspecialidadId INT NOT NULL,
    ExperienciaFormacion TEXT,
    DescripcionProfesional TEXT,
    PrecioConsulta DECIMAL(10,2),
    EstadoVerificacion VARCHAR(20) DEFAULT 'pendiente' CHECK (EstadoVerificacion IN ('pendiente', 'aprobado', 'rechazado')),
    CalificacionPromedio DECIMAL(3,2) DEFAULT 0.0,
	EstadoMedico BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Medico PRIMARY KEY (IdMedico),
    CONSTRAINT FK_Medico_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula),
    CONSTRAINT FK_Medico_Especialidad FOREIGN KEY (EspecialidadId) REFERENCES Especialidad(IdEspecialidad)
);


-- EMAIL
CREATE TABLE Email (
    IdEmail INT IDENTITY(1,1) NOT NULL,
    Correo VARCHAR(255) NOT NULL,
    DescripcionEmail VARCHAR(100) NOT NULL,
    CedulaId VARCHAR(9),
    EstadoEmail BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Email PRIMARY KEY (IdEmail),
    CONSTRAINT FK_Email_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


-- TELEFONO
CREATE TABLE Telefono (
    IdTelefono INT IDENTITY(1,1) NOT NULL,
    Numero VARCHAR(10) NOT NULL,
    DescripcionTelefono VARCHAR(100) NOT NULL,
    CedulaId VARCHAR(9),
    EstadoTelefono BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Telefono PRIMARY KEY (IdTelefono),
    CONSTRAINT FK_Telefono_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


-- DIRECCION
CREATE TABLE Direccion (
    IdDireccion INT IDENTITY(1,1) NOT NULL,
    Ciudad VARCHAR(20) NOT NULL,
    CodigoPostal VARCHAR(20) NOT NULL,
    CedulaId VARCHAR(9),
    EstadoDireccion BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Direccion PRIMARY KEY (IdDireccion),
    CONSTRAINT FK_Direccion_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


-- ROLES
CREATE TABLE Rol (
    IdRol INT IDENTITY(1,1) NOT NULL,
    NombreRol VARCHAR(30) NOT NULL,
    DescripcionRol VARCHAR(100) NOT NULL,
    Estado BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Roles PRIMARY KEY (IdRol)
);


-- PERMISOS
CREATE TABLE Permiso (
    IdPermiso INT IDENTITY(1,1) NOT NULL,
    NombrePermiso VARCHAR(100) NOT NULL,
    DescripcionPermiso VARCHAR(100) NOT NULL,
    EstadoPermiso BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Permisos PRIMARY KEY (IdPermiso)
);


-- PERMISOS POR ROL
CREATE TABLE PermisosRol (
    IdPermisoRol INT IDENTITY(1,1) NOT NULL,
    RolId INT NOT NULL,
    PermisoId INT NOT NULL,
    CONSTRAINT PK_PermisosRol PRIMARY KEY (IdPermisoRol),
    CONSTRAINT FK_PermisosRol_Rol FOREIGN KEY (RolId) REFERENCES Rol(IdRol),
    CONSTRAINT FK_PermisosRol_Permiso FOREIGN KEY (PermisoId) REFERENCES Permisos(IdPermiso),
    CONSTRAINT UQ_Rol_Permiso UNIQUE (RolId, PermisoId)
);


-- USUARIO
CREATE TABLE Usuario (
    IdUsuario INT IDENTITY(1,1) NOT NULL,
    Username VARCHAR(30) NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    RolId INT NOT NULL,
    CedulaId VARCHAR(9) NOT NULL,
    EstadoUsuario BIT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_Usuario PRIMARY KEY (IdUsuario),
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (RolId) REFERENCES Roles(IdRol),
    CONSTRAINT FK_Usuario_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


-- HORARIO DISPONIBLE
CREATE TABLE HorarioDisponible (
    IdHorario INT IDENTITY(1,1) NOT NULL,
    MedicoId INT NOT NULL,
    Fecha DATE NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    Disponible BIT DEFAULT 1,
    CONSTRAINT PK_Horario PRIMARY KEY (IdHorario),
    CONSTRAINT FK_Horario_Medico FOREIGN KEY (MedicoId) REFERENCES Medico(IdMedico)
);


-- CITA
CREATE TABLE Cita (
    IdCita INT IDENTITY(1,1) NOT NULL,
    MedicoId INT NOT NULL,
    PacienteId INT NOT NULL,
    HorarioId INT NOT NULL,
    Modalidad VARCHAR(20) CHECK (Modalidad IN ('presencial', 'virtual')),
	FechaReserva DATETIME DEFAULT GETDATE(),
    EstadoCita VARCHAR(20) DEFAULT 'pendiente' CHECK (EstadoCita IN ('pendiente', 'confirmada', 'cancelada', 'realizada')),
    CONSTRAINT PK_Cita PRIMARY KEY (IdCita),
    CONSTRAINT FK_Cita_Medico FOREIGN KEY (MedicoId) REFERENCES Medico(IdMedico),
    CONSTRAINT FK_Cita_Paciente FOREIGN KEY (PacienteId) REFERENCES Paciente(IdPaciente),
    CONSTRAINT FK_Cita_Horario FOREIGN KEY (HorarioId) REFERENCES HorarioDisponible(IdHorario)
);


-- HISTORIAL CITA
CREATE TABLE HistorialCita (
    IdHistorial INT IDENTITY(1,1) NOT NULL,
    NotasMedico TEXT,
    FechaRegistro DATE NOT NULL,
    Diagnostico VARCHAR(100) NOT NULL,
    Receta VARCHAR (100) NOT NULL,
	CitaId INT NOT NULL,
    CONSTRAINT PK_Cita PRIMARY KEY (IdHistorial),
    CONSTRAINT FK_Historial_Cita FOREIGN KEY (CitaId) REFERENCES Cita(IdCita)
);


-- CALIFICACION
CREATE TABLE Calificacion (
    IdCalificacion INT IDENTITY(1,1) NOT NULL,
    CitaId INT NOT NULL,
    Puntuacion INT CHECK (Puntuacion BETWEEN 1 AND 5),
    Comentario TEXT,
    FechaCalificacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Calificacion PRIMARY KEY (IdCalificacion),
    CONSTRAINT FK_Calificacion_Cita FOREIGN KEY (CitaId) REFERENCES Cita(IdCita)
);


-- TIPO MEMBRESIA
CREATE TABLE TipoMembresia (
    IdTipoMembresia INT IDENTITY(1,1) NOT NULL,
    NombreTM VARCHAR(50) NOT NULL,
    DescripcionTM TEXT,
    Precio DECIMAL(10,2) NOT NULL,
    DuracionDias INT NOT NULL,
    CONSTRAINT PK_TipoMembresia PRIMARY KEY (IdTipoMembresia)
);


-- MEMBRESIA
CREATE TABLE Membresia (
    IdMembresia INT IDENTITY(1,1) NOT NULL,
    CedulaId VARCHAR(9) NOT NULL,
    TipoMembresiaId INT NOT NULL,
    FechaInicio DATE NOT NULL DEFAULT GETDATE(),
    FechaFin DATE NOT NULL,
    Estado VARCHAR(20) DEFAULT 'activa' CHECK (Estado IN ('activa', 'vencida', 'cancelada')),
    CONSTRAINT PK_Membresia PRIMARY KEY (IdMembresia),
    CONSTRAINT FK_Membresia_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula),
    CONSTRAINT FK_Membresia_Tipo FOREIGN KEY (TipoMembresiaId) REFERENCES TipoMembresia(IdTipoMembresia)
);


-- FACTURA
CREATE TABLE Factura (
    IdFactura INT IDENTITY(1,1) NOT NULL,
    CedulaId VARCHAR(9) NOT NULL,
    FechaEmision DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    Tipo VARCHAR(20) CHECK (Tipo IN ('membresia', 'consulta')),
    EstadoFactura VARCHAR(20) DEFAULT 'pendiente' CHECK (EstadoFactura IN ('pendiente', 'pagado', 'anulado')),
    CONSTRAINT PK_Factura PRIMARY KEY (IdFactura),
    CONSTRAINT FK_Factura_Persona FOREIGN KEY (CedulaId) REFERENCES Persona(Cedula)
);


-- DETALLE FACTURA
CREATE TABLE DetalleFactura (
    IdDetalle INT IDENTITY(1,1) NOT NULL,
    FacturaId INT NOT NULL,
    Descripcion VARCHAR(100) NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal AS (Cantidad * PrecioUnitario) NOT NULL,
    CONSTRAINT PK_DetalleFactura PRIMARY KEY (IdDetalle),
    CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (FacturaId) REFERENCES Factura(IdFactura)
);



--PROCEDIMIENTOS ALMACENADOS

-- PERSONA SP
CREATE PROCEDURE SP_Persona
    @opc INT,
    @Cedula VARCHAR(9) = NULL,
    @Nombre1 VARCHAR(30) = NULL,
    @Nombre2 VARCHAR(30) = NULL,
    @Ap1 VARCHAR(30) = NULL,
    @Ap2 VARCHAR(30) = NULL,
    @Sexo VARCHAR(10) = NULL,
    @FechaNacimiento DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Persona;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Persona WHERE Cedula = @Cedula;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Persona (Cedula, Nombre1, Nombre2, Ap1, Ap2, Sexo, FechaNacimiento)
        VALUES (@Cedula, @Nombre1, @Nombre2, @Ap1, @Ap2, @Sexo, @FechaNacimiento);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Persona
        SET Nombre1 = @Nombre1,
            Nombre2 = @Nombre2,
            Ap1 = @Ap1,
            Ap2 = @Ap2,
            Sexo = @Sexo,
            FechaNacimiento = @FechaNacimiento
        WHERE Cedula = @Cedula;
    END
END


-- PACIENTE SP
CREATE PROCEDURE SP_Paciente
    @opc INT,
    @IdPaciente INT = NULL,
    @CedulaId VARCHAR(9) = NULL,
    @GrupoSanguineo VARCHAR(3) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Paciente WHERE EstadoPaciente = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Paciente WHERE IdPaciente = @IdPaciente;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Paciente (CedulaId, GrupoSanguineo)
        VALUES (@CedulaId, @GrupoSanguineo);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Paciente
        SET GrupoSanguineo = @GrupoSanguineo
        WHERE IdPaciente = @IdPaciente;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Paciente
        SET EstadoPaciente = 0
        WHERE IdPaciente = @IdPaciente;
    END
END


-- EXPEDIENTE SP
CREATE PROCEDURE SP_Expediente
    @opc INT,
    @IdExpediente INT = NULL,
    @PacienteId INT = NULL,
    @Alergias VARCHAR(100) = NULL,
    @FechaCreacion DATE = NULL,
    @ObservacionesGenerales TEXT = NULL,
    @EstadoExpediente BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN -- Listar todos
        SELECT * FROM Expediente WHERE EstadoExpediente = 1;
    END
    ELSE IF @opc = 2
    BEGIN -- Obtener uno
        SELECT * FROM Expediente WHERE IdExpediente = @IdExpediente;
    END
    ELSE IF @opc = 3
    BEGIN -- Insertar
        INSERT INTO Expediente (PacienteId, Alergias, FechaCreacion, ObservacionesGenerales, EstadoExpediente)
        VALUES (@PacienteId, @Alergias, ISNULL(@FechaCreacion, GETDATE()), @ObservacionesGenerales, 1);
    END
    ELSE IF @opc = 4
    BEGIN -- Actualizar
        UPDATE Expediente
        SET PacienteId = @PacienteId,
            Alergias = @Alergias,
            FechaCreacion = @FechaCreacion,
            ObservacionesGenerales = @ObservacionesGenerales
        WHERE IdExpediente = @IdExpediente;
    END
    ELSE IF @opc = 5
    BEGIN -- Eliminación lógica
        UPDATE Expediente SET EstadoExpediente = 0 WHERE IdExpediente = @IdExpediente;
    END
END;


-- EXAMEN RADIOLOGICO SP
CREATE PROCEDURE SP_ExamenRadiologico
    @opc INT,
    @IdExamenRad INT = NULL,
    @ExpedienteId INT = NULL,
    @FechaExamen DATE = NULL,
    @TipoImagen VARCHAR(100) = NULL,
    @InformeRadiologico TEXT = NULL,
    @URLImagen VARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM ExamenRadiologico;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM ExamenRadiologico WHERE IdExamenRad = @IdExamenRad;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO ExamenRadiologico (ExpedienteId, FechaExamen, TipoImagen, InformeRadiologico, URLImagen)
        VALUES (@ExpedienteId, @FechaExamen, @TipoImagen, @InformeRadiologico, @URLImagen);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE ExamenRadiologico
        SET ExpedienteId = @ExpedienteId,
            FechaExamen = @FechaExamen,
            TipoImagen = @TipoImagen,
            InformeRadiologico = @InformeRadiologico,
            URLImagen = @URLImagen
        WHERE IdExamenRad = @IdExamenRad;
    END
END;


-- EXAMEN LABORATORIO SP
CREATE PROCEDURE SP_ExamenLaboratorio
    @opc INT,
    @IdExamenLab INT = NULL,
    @ExpedienteId INT = NULL,
    @FechaLaboratorio DATE = NULL,
    @TipoAnalisis VARCHAR(100) = NULL,
    @ResultadoAnalisis TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM ExamenLaboratorio;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM ExamenLaboratorio WHERE IdExamenLab = @IdExamenLab;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO ExamenLaboratorio (ExpedienteId, FechaLaboratorio, TipoAnalisis, ResultadoAnalisis)
        VALUES (@ExpedienteId, @FechaLaboratorio, @TipoAnalisis, @ResultadoAnalisis);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE ExamenLaboratorio
        SET ExpedienteId = @ExpedienteId,
            FechaLaboratorio = @FechaLaboratorio,
            TipoAnalisis = @TipoAnalisis,
            ResultadoAnalisis = @ResultadoAnalisis
        WHERE IdExamenLab = @IdExamenLab;
    END
END;


-- EXAMNEN OPERACION
CREATE PROCEDURE SP_Operacion
    @opc INT,
    @IdOperacion INT = NULL,
    @ExpedienteId INT = NULL,
    @FechaOperacion DATE = NULL,
    @NombreOperacion VARCHAR(100) = NULL,
    @DescripcionOperacion TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Operacion;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Operacion WHERE IdOperacion = @IdOperacion;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Operacion (ExpedienteId, FechaOperacion, NombreOperacion, DescripcionOperacion)
        VALUES (@ExpedienteId, @FechaOperacion, @NombreOperacion, @DescripcionOperacion);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Operacion
        SET ExpedienteId = @ExpedienteId,
            FechaOperacion = @FechaOperacion,
            NombreOperacion = @NombreOperacion,
            DescripcionOperacion = @DescripcionOperacion
        WHERE IdOperacion = @IdOperacion;
    END
END;


-- ESPECIALIDAD SP
CREATE PROCEDURE SP_Especialidad
    @opc INT,
    @IdEspecialidad INT = NULL,
    @NombreEspecialidad VARCHAR(50) = NULL,
    @DescripcionEspecialidad TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Especialidad WHERE EstadoEspecialidad = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Especialidad WHERE IdEspecialidad = @IdEspecialidad;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Especialidad (NombreEspecialidad, DescripcionEspecialidad)
        VALUES (@NombreEspecialidad, @DescripcionEspecialidad);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Especialidad
        SET NombreEspecialidad = @NombreEspecialidad,
            DescripcionEspecialidad = @DescripcionEspecialidad
        WHERE IdEspecialidad = @IdEspecialidad;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Especialidad
        SET EstadoEspecialidad = 0
        WHERE IdEspecialidad = @IdEspecialidad;
    END
END


-- MEDICO SP
CREATE PROCEDURE SP_Medico
    @opc INT,
    @IdMedico INT = NULL,
    @CedulaId VARCHAR(9) = NULL,
    @EspecialidadId INT = NULL,
    @ExperienciaFormacion TEXT = NULL,
    @DescripcionProfesional TEXT = NULL,
    @PrecioConsulta DECIMAL(10,2) = NULL,
    @EstadoVerificacion VARCHAR(20) = NULL,
    @CalificacionPromedio DECIMAL(3,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Medico WHERE EstadoMedico = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Medico WHERE IdMedico = @IdMedico;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Medico (CedulaId, EspecialidadId, ExperienciaFormacion, DescripcionProfesional,
            PrecioConsulta, EstadoVerificacion, CalificacionPromedio)
        VALUES (@CedulaId, @EspecialidadId, @ExperienciaFormacion, @DescripcionProfesional,
            @PrecioConsulta, @EstadoVerificacion, @CalificacionPromedio);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Medico
        SET CedulaId = @CedulaId,
            EspecialidadId = @EspecialidadId,
            ExperienciaFormacion = @ExperienciaFormacion,
            DescripcionProfesional = @DescripcionProfesional,
            PrecioConsulta = @PrecioConsulta,
            EstadoVerificacion = @EstadoVerificacion,
            CalificacionPromedio = @CalificacionPromedio
        WHERE IdMedico = @IdMedico;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Medico
        SET EstadoMedico = 0
        WHERE IdMedico = @IdMedico;
    END
END



-- EMAIL SP
CREATE PROCEDURE SP_Email
    @opc INT,
    @IdEmail INT = NULL,
    @Correo VARCHAR(255) = NULL,
    @DescripcionEmail VARCHAR(100) = NULL,
    @CedulaId VARCHAR(9) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Email WHERE EstadoEmail = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Email WHERE IdEmail = @IdEmail;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Email (Correo, DescripcionEmail, CedulaId)
        VALUES (@Correo, @DescripcionEmail, @CedulaId);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Email
        SET Correo = @Correo,
            DescripcionEmail = @DescripcionEmail,
            CedulaId = @CedulaId
        WHERE IdEmail = @IdEmail;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Email
        SET EstadoEmail = 0
        WHERE IdEmail = @IdEmail;
    END
END


-- TELEFONO SP
CREATE PROCEDURE SP_Telefono
    @opc INT,
    @IdTelefono INT = NULL,
    @Numero VARCHAR(10) = NULL,
    @DescripcionTelefono VARCHAR(100) = NULL,
    @CedulaId VARCHAR(9) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Telefono WHERE EstadoTelefono = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Telefono WHERE IdTelefono = @IdTelefono;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Telefono (Numero, DescripcionTelefono, CedulaId)
        VALUES (@Numero, @DescripcionTelefono, @CedulaId);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Telefono
        SET Numero = @Numero,
            DescripcionTelefono = @DescripcionTelefono,
            CedulaId = @CedulaId
        WHERE IdTelefono = @IdTelefono;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Telefono
        SET EstadoTelefono = 0
        WHERE IdTelefono = @IdTelefono;
    END
END


--DIRECCION SP
CREATE PROCEDURE SP_Direccion
    @opc INT,
    @IdDireccion INT = NULL,
    @Ciudad VARCHAR(20) = NULL,
    @CodigoPostal VARCHAR(20) = NULL,
    @CedulaId VARCHAR(9) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Direccion WHERE EstadoDireccion = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Direccion WHERE IdDireccion = @IdDireccion;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Direccion (Ciudad, CodigoPostal, CedulaId)
        VALUES (@Ciudad, @CodigoPostal, @CedulaId);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Direccion
        SET Ciudad = @Ciudad,
            CodigoPostal = @CodigoPostal,
            CedulaId = @CedulaId
        WHERE IdDireccion = @IdDireccion;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Direccion
        SET EstadoDireccion = 0
        WHERE IdDireccion = @IdDireccion;
    END
END


--ROL SP
CREATE PROCEDURE SP_Rol
    @opc INT,
    @IdRol INT = NULL,
    @NombreRol VARCHAR(30) = NULL,
    @DescripcionRol VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Rol WHERE Estado = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Rol WHERE IdRol = @IdRol;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Rol (NombreRol, DescripcionRol)
        VALUES (@NombreRol, @DescripcionRol);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Rol
        SET NombreRol = @NombreRol,
            DescripcionRol = @DescripcionRol
        WHERE IdRol = @IdRol;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Rol
        SET Estado = 0
        WHERE IdRol = @IdRol;
    END
END


-- PERMISO SP
CREATE PROCEDURE SP_Permiso
    @opc INT,
    @IdPermiso INT = NULL,
    @NombrePermiso VARCHAR(100) = NULL,
    @DescripcionPermiso VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Permiso WHERE EstadoPermiso = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Permiso WHERE IdPermiso = @IdPermiso;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Permiso (NombrePermiso, DescripcionPermiso)
        VALUES (@NombrePermiso, @DescripcionPermiso);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Permiso
        SET NombrePermiso = @NombrePermiso,
            DescripcionPermiso = @DescripcionPermiso
        WHERE IdPermiso = @IdPermiso;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Permiso
        SET EstadoPermiso = 0
        WHERE IdPermiso = @IdPermiso;
    END
END


-- PERMISOROL SP
CREATE PROCEDURE SP_PermisoRol
    @opc INT,
    @IdPermisoRol INT = NULL,
    @RolId INT = NULL,
    @PermisoId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT PR.IdPermisoRol, R.NombreRol, P.NombrePermiso
        FROM PermisosRol PR
        JOIN Rol R ON PR.RolId = R.IdRol
        JOIN Permiso P ON PR.PermisoId = P.IdPermiso;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM PermisosRol WHERE IdPermisoRol = @IdPermisoRol;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO PermisosRol (RolId, PermisoId)
        VALUES (@RolId, @PermisoId);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE PermisosRol
        SET RolId = @RolId,
            PermisoId = @PermisoId
        WHERE IdPermisoRol = @IdPermisoRol;
    END
END


-- USUARIO SP
CREATE PROCEDURE SP_Usuario
    @opc INT,
    @IdUsuario INT = NULL,
    @Username VARCHAR(30) = NULL,
    @Contrasena VARCHAR(255) = NULL,
    @RolId INT = NULL,
    @CedulaId VARCHAR(9) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM Usuario WHERE EstadoUsuario = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM Usuario WHERE IdUsuario = @IdUsuario;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO Usuario (Username, Contrasena, RolId, CedulaId)
        VALUES (@Username, @Contrasena, @RolId, @CedulaId);
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE Usuario
        SET Username = @Username,
            Contrasena = @Contrasena,
            RolId = @RolId,
            CedulaId = @CedulaId
        WHERE IdUsuario = @IdUsuario;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE Usuario
        SET EstadoUsuario = 0
        WHERE IdUsuario = @IdUsuario;
    END
END


-- HORARIO DISPONIBLE SP
CREATE PROCEDURE SP_HorarioDisponible
    @opc INT,
    @IdHorario INT = NULL,
    @MedicoId INT = NULL,
    @Fecha DATE = NULL,
    @HoraInicio TIME = NULL,
    @HoraFin TIME = NULL,
    @Disponible BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
    BEGIN
        SELECT * FROM HorarioDisponible WHERE Disponible = 1;
    END
    ELSE IF @opc = 2
    BEGIN
        SELECT * FROM HorarioDisponible WHERE IdHorario = @IdHorario;
    END
    ELSE IF @opc = 3
    BEGIN
        INSERT INTO HorarioDisponible (MedicoId, Fecha, HoraInicio, HoraFin, Disponible)
        VALUES (@MedicoId, @Fecha, @HoraInicio, @HoraFin, ISNULL(@Disponible, 1));
    END
    ELSE IF @opc = 4
    BEGIN
        UPDATE HorarioDisponible
        SET MedicoId = @MedicoId,
            Fecha = @Fecha,
            HoraInicio = @HoraInicio,
            HoraFin = @HoraFin,
            Disponible = @Disponible
        WHERE IdHorario = @IdHorario;
    END
    ELSE IF @opc = 5
    BEGIN
        UPDATE HorarioDisponible
        SET Disponible = 0
        WHERE IdHorario = @IdHorario;
    END
END


-- CITA SP
CREATE PROCEDURE SP_Cita
    @opc INT,
    @IdCita INT = NULL,
    @MedicoId INT = NULL,
    @PacienteId INT = NULL,
    @HorarioId INT = NULL,
    @Modalidad VARCHAR(20) = NULL,
    @FechaReserva DATETIME = NULL,
    @EstadoCita VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM Cita;

    ELSE IF @opc = 2
        SELECT * FROM Cita WHERE IdCita = @IdCita;

    ELSE IF @opc = 3
        INSERT INTO Cita (MedicoId, PacienteId, HorarioId, Modalidad, FechaReserva, EstadoCita)
        VALUES (@MedicoId, @PacienteId, @HorarioId, @Modalidad, ISNULL(@FechaReserva, GETDATE()), @EstadoCita);

    ELSE IF @opc = 4
        UPDATE Cita
        SET MedicoId = @MedicoId,
            PacienteId = @PacienteId,
            HorarioId = @HorarioId,
            Modalidad = @Modalidad,
            FechaReserva = @FechaReserva,
            EstadoCita = @EstadoCita
        WHERE IdCita = @IdCita;

END;


--HISTORIAL CITA SP
CREATE PROCEDURE SP_HistorialCita
    @opc INT,
    @IdHistorial INT = NULL,
    @NotasMedico TEXT = NULL,
    @FechaRegistro DATE = NULL,
    @Diagnostico VARCHAR(100) = NULL,
    @Receta VARCHAR(100) = NULL,
    @CitaId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM HistorialCita;

    ELSE IF @opc = 2
        SELECT * FROM HistorialCita WHERE IdHistorial = @IdHistorial;

    ELSE IF @opc = 3
        INSERT INTO HistorialCita (NotasMedico, FechaRegistro, Diagnostico, Receta, CitaId)
        VALUES (@NotasMedico, @FechaRegistro, @Diagnostico, @Receta, @CitaId);

    ELSE IF @opc = 4
        UPDATE HistorialCita
        SET NotasMedico = @NotasMedico,
            FechaRegistro = @FechaRegistro,
            Diagnostico = @Diagnostico,
            Receta = @Receta,
            CitaId = @CitaId
        WHERE IdHistorial = @IdHistorial;

END;


-- CALIFICACION SP
CREATE PROCEDURE SP_Calificacion
    @opc INT,
    @IdCalificacion INT = NULL,
    @CitaId INT = NULL,
    @Puntuacion INT = NULL,
    @Comentario TEXT = NULL,
    @FechaCalificacion DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM Calificacion;

    ELSE IF @opc = 2
        SELECT * FROM Calificacion WHERE IdCalificacion = @IdCalificacion;

    ELSE IF @opc = 3
        INSERT INTO Calificacion (CitaId, Puntuacion, Comentario, FechaCalificacion)
        VALUES (@CitaId, @Puntuacion, @Comentario, ISNULL(@FechaCalificacion, GETDATE()));

    ELSE IF @opc = 4
        UPDATE Calificacion
        SET CitaId = @CitaId,
            Puntuacion = @Puntuacion,
            Comentario = @Comentario,
            FechaCalificacion = @FechaCalificacion
        WHERE IdCalificacion = @IdCalificacion;

    ELSE IF @opc = 5
        DELETE FROM Calificacion WHERE IdCalificacion = @IdCalificacion;
END;


-- TIPO MEMBRESIA SP
CREATE PROCEDURE SP_TipoMembresia
    @opc INT,
    @IdTipoMembresia INT = NULL,
    @NombreTM VARCHAR(50) = NULL,
    @DescripcionTM TEXT = NULL,
    @Precio DECIMAL(10,2) = NULL,
    @DuracionDias INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM TipoMembresia;

    ELSE IF @opc = 2
        SELECT * FROM TipoMembresia WHERE IdTipoMembresia = @IdTipoMembresia;

    ELSE IF @opc = 3
        INSERT INTO TipoMembresia (NombreTM, DescripcionTM, Precio, DuracionDias)
        VALUES (@NombreTM, @DescripcionTM, @Precio, @DuracionDias);

    ELSE IF @opc = 4
        UPDATE TipoMembresia
        SET NombreTM = @NombreTM,
            DescripcionTM = @DescripcionTM,
            Precio = @Precio,
            DuracionDias = @DuracionDias
        WHERE IdTipoMembresia = @IdTipoMembresia;

    ELSE IF @opc = 5
        DELETE FROM TipoMembresia WHERE IdTipoMembresia = @IdTipoMembresia;
END;


-- MEMBRESIA SP
CREATE PROCEDURE SP_Membresia
    @opc INT,
    @IdMembresia INT = NULL,
    @CedulaId VARCHAR(9) = NULL,
    @TipoMembresiaId INT = NULL,
    @FechaInicio DATE = NULL,
    @FechaFin DATE = NULL,
    @Estado VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM Membresia;

    ELSE IF @opc = 2
        SELECT * FROM Membresia WHERE IdMembresia = @IdMembresia;

    ELSE IF @opc = 3
        INSERT INTO Membresia (CedulaId, TipoMembresiaId, FechaInicio, FechaFin, Estado)
        VALUES (@CedulaId, @TipoMembresiaId, ISNULL(@FechaInicio, GETDATE()), @FechaFin, ISNULL(@Estado, 'activa'));

    ELSE IF @opc = 4
        UPDATE Membresia
        SET CedulaId = @CedulaId,
            TipoMembresiaId = @TipoMembresiaId,
            FechaInicio = @FechaInicio,
            FechaFin = @FechaFin,
            Estado = @Estado
        WHERE IdMembresia = @IdMembresia;

END;


-- FACTURA SP
CREATE PROCEDURE SP_Factura
    @opc INT,
    @IdFactura INT = NULL,
    @CedulaId VARCHAR(9) = NULL,
    @FechaEmision DATETIME = NULL,
    @Total DECIMAL(10,2) = NULL,
    @Tipo VARCHAR(20) = NULL,
    @EstadoFactura VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT * FROM Factura;

    ELSE IF @opc = 2
        SELECT * FROM Factura WHERE IdFactura = @IdFactura;

    ELSE IF @opc = 3
        INSERT INTO Factura (CedulaId, FechaEmision, Total, Tipo, EstadoFactura)
        VALUES (@CedulaId, ISNULL(@FechaEmision, GETDATE()), @Total, @Tipo, ISNULL(@EstadoFactura, 'pendiente'));

    ELSE IF @opc = 4
        UPDATE Factura
        SET CedulaId = @CedulaId,
            FechaEmision = @FechaEmision,
            Total = @Total,
            Tipo = @Tipo,
            EstadoFactura = @EstadoFactura
        WHERE IdFactura = @IdFactura;

END;


-- DETALLE FACTURA SP
CREATE PROCEDURE SP_DetalleFactura
    @opc INT,
    @IdDetalle INT = NULL,
    @FacturaId INT = NULL,
    @Descripcion VARCHAR(100) = NULL,
    @Cantidad INT = NULL,
    @PrecioUnitario DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @opc = 1
        SELECT *, (Cantidad * PrecioUnitario) AS Subtotal FROM DetalleFactura;

    ELSE IF @opc = 2
        SELECT *, (Cantidad * PrecioUnitario) AS Subtotal FROM DetalleFactura WHERE IdDetalle = @IdDetalle;

    ELSE IF @opc = 3
        INSERT INTO DetalleFactura (FacturaId, Descripcion, Cantidad, PrecioUnitario)
        VALUES (@FacturaId, @Descripcion, ISNULL(@Cantidad, 1), @PrecioUnitario);

    ELSE IF @opc = 4
        UPDATE DetalleFactura
        SET FacturaId = @FacturaId,
            Descripcion = @Descripcion,
            Cantidad = @Cantidad,
            PrecioUnitario = @PrecioUnitario
        WHERE IdDetalle = @IdDetalle;

END;


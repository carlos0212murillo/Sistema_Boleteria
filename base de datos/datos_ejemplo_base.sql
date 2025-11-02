INSERT INTO Roles (id_rol, nombre_rol) VALUES
(1, 'cliente'),
(2, 'vendedor'),
(3, 'admin');


INSERT INTO Usuarios (dni_usuario, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, correo, contrasena, telefono, direccion)
VALUES
('0801199901234', 'Carlos', 'Eduardo', 'Ramirez', 'Lopez', 'carlos@mail.com', 'pass123', '98761234', 'Col. Kennedy, Tegucigalpa'),
('0801200104567', 'Maria', 'Jose', 'Hernandez', 'Castillo', 'maria@mail.com', 'pass123', '99887766', 'Col. Trejo, SPS'),
('0801199807890', 'Luis', 'Fernando', 'Martinez', 'Rivera', 'luis@mail.com', 'pass123', '99663322', 'Barrio Abajo, Tegucigalpa'),
('0801199501122', 'Ana', 'Gabriela', 'Castro', 'Mendoza', 'ana@mail.com', 'pass123', '94561234', 'Col. Miraflores, Tegucigalpa'),
('0801200203344', 'Jorge', 'Andres', 'Pineda', 'Mejia', 'jorge@mail.com', 'pass123', '90112233', 'Col. Las Palmas, La Ceiba'),
('0801199705566', 'Kevin', 'Daniel', 'Lopez', 'Gomez', 'kevin@mail.com', 'pass123', '90887711', 'Col. Monte Carlo, SPS');


INSERT INTO Usuarios_Roles (id_usuario, id_rol) VALUES
(1, 1), -- Carlos cliente
(2, 1), -- Maria cliente
(3, 1), -- Luis cliente
(4, 2), -- Ana vendedora
(5, 2), -- Jorge vendedor
(6, 3), -- Kevin admin
(6, 2); -- Kevin también es vendedor


INSERT INTO Clientes (id_usuario) VALUES (1), (2), (3);
INSERT INTO Vendedores (id_usuario) VALUES (4), (5), (6);
INSERT INTO Administradores (id_usuario) VALUES (6);


INSERT INTO Eventos (nombre, descripcion, fecha_inicio, fecha_fin, lugar, categoria, id_vendedor, precio_base, cantidad_boletos)
VALUES
('Olimpia vs Motagua', 'Clásico capitalino', '2025-02-02 19:00:00', NULL, 'Estadio Nacional', 'Fútbol', 4, 150.00, 5000),
('Bad Bunny World Tour', 'Concierto en Tegucigalpa', '2025-03-10 20:00:00', NULL, 'Estadio Chochi Sosa', 'Concierto', 5, 1200.00, 8000),
('Festival de Comida Hondureña', 'Evento gastronómico', '2025-01-25 10:00:00', '2025-01-25 18:00:00', 'Parque Central SPS', 'Cultural', 4, 100.00, 1000),
('Obra de Teatro: El Quijote', 'Presentación teatral', '2025-02-15 18:30:00', NULL, 'Teatro Nacional Manuel Bonilla', 'Teatro', 5, 250.00, 400),
('Maratón de San Pedro Sula', 'Carrera 10K', '2025-04-05 06:00:00', NULL, 'Centro SPS', 'Deporte', 4, 300.00, 2000);


INSERT INTO Categorias_Evento (id_evento, nombre_categoria, precio)
VALUES
-- Evento 1 (Fútbol)
(1, 'Sombra', 200.00),
(1, 'Sol', 150.00),
(1, 'VIP', 500.00),

-- Evento 2 (Concierto)
(2, 'General', 1200.00),
(2, 'VIP', 2500.00),
(2, 'Platino', 4000.00),

-- Evento 4 (Teatro)
(4, 'Platea', 300.00),
(4, 'Balcón', 250.00);


INSERT INTO Boletos (codigo, id_evento, asiento, precio, estado, id_categoria)
VALUES
('QR001', 1, 'A-12', 200.00, 'validado',1),
('QR002', 1, 'A-13', 200.00, 'pagado', 2),
('QR003', 1, NULL, 150.00, 'pagado', 4),
('QR004', 2, 'VIP-01', 2500.00, 'pagado', 6),
('QR005', 2, NULL, 1200.00, 'usado', 2),
('QR006', 4, 'PL-07', 300.00, 'usado', 3),
('QR007', 4, 'BA-10', 250.00, 'pendiente', 5),
('QR008', 5, NULL, 300.00, 'validado', 2);


INSERT INTO Compras (id_cliente, total, metodo_pago, estado)
VALUES
(1, 350.00, 'tarjeta', 'completado'),
(2, 2500.00, 'paypal', 'completado'),
(3, 300.00, 'tarjeta', 'completado');


INSERT INTO Detalle_Compras (id_compra, id_boleto, precio)
VALUES
(1, 2, 200.00),
(1, 3, 150.00),
(2, 4, 2500.00),
(3, 6, 300.00);


INSERT INTO Pagos (id_compra, monto, metodo, estado)
VALUES
(1, 350.00, 'tarjeta', 'exitoso'),
(2, 2500.00, 'paypal', 'exitoso'),
(3, 300.00, 'tarjeta', 'exitoso');



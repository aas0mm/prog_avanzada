# TrendWear 

## Nombre del proyecto
 TrendWear: Sistema de gestión de ventas y productos, diseñado para la administración de inventario de vestuario, control de clientes y procesos de venta.

## Descripción del problema

Para la administración efectiva de productos, clientes, trabajadores y ventas es necesario que las empresas cuenten con un sistema que refleje sus componentes de manera organizada y transparente. El mercado de prendas de vestir es una de los principales comercios de nuestra sociedad, y permite representar de manera clara la jerarquía de clases dentro de una empresa y la necesidad la tecnología para gestionarla de manera ordenada.

---

## Usuarios del sistema

**Cliente/Comprador:** Persona interesada en adquirir o cotizar los productos (poleras, polerones o pantalones)

**Empleado:** Atiende a los clientes, procesa las ventas y realiza el registro del movimiento de los productos en el sistema.

## Entidades principales

### Persona

**Atributos:** `nombre (String)`, `rut (String)`, `teléfono (Int)` y `correo (String)`.

**Subclases:** 
- Cliente: Añade `idCliente (Int)` y la operación de registro en el sistema.
- Empleado: Añade `sueldo (Int)`, `idEmpleado (Int)`, cargo (String) y la operación de registro.

### Producto (Prendas)
**Atributos Generales:** `codigo (String)`, `nombre (String)`, `precio (Int)`, `marca (String)`, `talla (String/Int)` y `stock (Int).`

## Operaciones que permitirá el sistema

### Operación 1: Gestión de Personas 
- Permite registrar y administrar a los clientes que compran en la tienda, así como al personale encargado de la gestión de la empresa utilizando la clase abstracta _Persona_

### Operación 2: Control de Inventario y Catálogo de Prendas
- Permite visualizar y gestionar el stock de los diferentes tipos de prendas a la venta (poleras, polerones y pantalones), actualizando las cantidades disponibles mediante `actualizar_stock()` y aplicando descuentos a través de la interfaz `Descuentos`.

### Operación 3: Administración de ventas y precios
- Permite calcular el precio total de cada venta, aplicando descuentos si corresponde, y procesar los pagos, todo esto mediante métodos como `calcular_Subtotal()`, `calcular_Total()`, `aplicarDescuento` y `procesar_Pago()`

---

package com.lab04;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.border.EmptyBorder;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class CarritoGUI extends JFrame {
    private CarritoCompra carrito;
    private DefaultTableModel tableModelCatalogo;
    private DefaultTableModel tableModelCarrito;
    private JLabel lblSubtotal;
    private JLabel lblDescuento;
    private JLabel lblImpuesto;
    private JLabel lblTotal;
    private JTextArea txtHistorial;
    
    // Catalogo de productos
    private Producto[] catalogo = {
        new Producto("P001", "Laptop Gamer", 3500.0, true),
        new Producto("P002", "Mouse RGB", 85.0, true),
        new Producto("P003", "Teclado Mecanico", 250.0, true),
        new Producto("P004", "Monitor 24\"", 850.0, true),
        new Producto("P005", "Audifonos Bluetooth", 180.0, true),
        new Producto("P006", "Disco SSD 1TB", 380.0, true),
        new Producto("P007", "Memoria USB 64GB", 45.0, true),
        new Producto("P008", "Camara Web HD", 120.0, true),
        new Producto("P009", "Silla Gamer", 1200.0, true),
        new Producto("P010", "Pad Mouse XXL", 65.0, true)
    };
    
    public CarritoGUI() {
        // Configurar servicio de precios
        ServicioPrecio servicioPrecio = new ServicioPrecio() {
            @Override
            public double calcularDescuento(double monto) {
                if (monto >= 1000) {
                    return monto * 0.10;
                } else if (monto >= 500) {
                    return monto * 0.05;
                }
                return 0;
            }
            
            @Override
            public double calcularImpuesto(double monto) {
                return monto * 0.18;
            }
        };
        
        carrito = new CarritoCompra(servicioPrecio);
        
        // Configurar ventana principal
        setTitle("Sistema de Carrito de Compras");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1200, 700);
        setLocationRelativeTo(null);
        setLayout(new BorderLayout(10, 10));
        
        // Crear paneles
        add(crearPanelSuperior(), BorderLayout.NORTH);
        add(crearPanelCentral(), BorderLayout.CENTER);
        add(crearPanelInferior(), BorderLayout.SOUTH);
        
        // Configurar atajos de teclado
        configurarAtajos();
        
        // Actualizar resumen
        actualizarResumen();
    }
    
    private JPanel crearPanelSuperior() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        panel.setBackground(new Color(52, 73, 94));
        
        JLabel titulo = new JLabel("SISTEMA DE CARRITO DE COMPRAS", SwingConstants.CENTER);
        titulo.setFont(new Font("Arial", Font.BOLD, 24));
        titulo.setForeground(Color.WHITE);
        
        JLabel subtitulo = new JLabel("Seleccione productos del catalogo y agreguelos a su carrito", SwingConstants.CENTER);
        subtitulo.setFont(new Font("Arial", Font.PLAIN, 12));
        subtitulo.setForeground(new Color(236, 240, 241));
        
        panel.add(titulo, BorderLayout.CENTER);
        panel.add(subtitulo, BorderLayout.SOUTH);
        
        return panel;
    }
    
    private JPanel crearPanelCentral() {
        JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        splitPane.setDividerLocation(600);
        splitPane.setBorder(new EmptyBorder(0, 10, 0, 10));
        
        // Panel izquierdo - Catalogo
        splitPane.setLeftComponent(crearPanelCatalogo());
        
        // Panel derecho - Carrito y resumen
        splitPane.setRightComponent(crearPanelCarrito());
        
        JPanel panel = new JPanel(new BorderLayout());
        panel.add(splitPane, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel crearPanelCatalogo() {
        JPanel panel = new JPanel(new BorderLayout(5, 5));
        panel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(52, 73, 94), 2),
            "CATALOGO DE PRODUCTOS",
            TitledBorder.DEFAULT_JUSTIFICATION,
            TitledBorder.DEFAULT_POSITION,
            new Font("Arial", Font.BOLD, 14),
            new Color(52, 73, 94)
        ));
        
        // Tabla de catalogo
        String[] columnas = {"ID", "Producto", "Precio (S/)", "Disponible"};
        tableModelCatalogo = new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        
        for (Producto p : catalogo) {
            tableModelCatalogo.addRow(new Object[]{
                p.getId(),
                p.getNombre(),
                String.format("%.2f", p.getPrecio()),
                p.isDisponible() ? "Si" : "No"
            });
        }
        
        JTable tablaCatalogo = new JTable(tableModelCatalogo);
        tablaCatalogo.setFont(new Font("Arial", Font.PLAIN, 12));
        tablaCatalogo.setRowHeight(25);
        tablaCatalogo.getSelectionModel().setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        
        JScrollPane scrollCatalogo = new JScrollPane(tablaCatalogo);
        panel.add(scrollCatalogo, BorderLayout.CENTER);
        
        // Panel de acciones para catalogo
        JPanel panelAcciones = new JPanel(new FlowLayout());
        
        JSpinner spinnerCantidad = new JSpinner(new SpinnerNumberModel(1, 1, 99, 1));
        spinnerCantidad.setPreferredSize(new Dimension(60, 30));
        
        JButton btnAgregar = new JButton("Agregar al Carrito");
        btnAgregar.setBackground(new Color(46, 204, 113));
        btnAgregar.setForeground(Color.BLACK);  // Cambiado a negro
        btnAgregar.setFocusPainted(false);
        btnAgregar.setFont(new Font("Arial", Font.BOLD, 12));
        
        btnAgregar.addActionListener(e -> {
            int selectedRow = tablaCatalogo.getSelectedRow();
            if (selectedRow >= 0) {
                int cantidad = (Integer) spinnerCantidad.getValue();
                Producto producto = catalogo[selectedRow];
                
                if (!producto.isDisponible()) {
                    JOptionPane.showMessageDialog(this, 
                        "El producto no esta disponible", 
                        "Error", JOptionPane.ERROR_MESSAGE);
                    return;
                }
                
                try {
                    carrito.agregar(producto, cantidad);
                    actualizarResumen();
                    actualizarCarrito();
                    actualizarHistorial();
                    JOptionPane.showMessageDialog(this,
                        producto.getNombre() + " (x" + cantidad + ") agregado al carrito",
                        "Exito", JOptionPane.INFORMATION_MESSAGE);
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(this,
                        ex.getMessage(),
                        "Error", JOptionPane.ERROR_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this,
                    "Seleccione un producto del catalogo",
                    "Advertencia", JOptionPane.WARNING_MESSAGE);
            }
        });
        
        panelAcciones.add(new JLabel("Cantidad:"));
        panelAcciones.add(spinnerCantidad);
        panelAcciones.add(btnAgregar);
        
        panel.add(panelAcciones, BorderLayout.SOUTH);
        
        return panel;
    }
    
    private JPanel crearPanelCarrito() {
        JPanel panel = new JPanel(new BorderLayout(5, 5));
        
        // Tabla del carrito
        String[] columnas = {"ID", "Producto", "Cantidad", "Precio Unit.", "Subtotal"};
        tableModelCarrito = new DefaultTableModel(columnas, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        
        JTable tablaCarrito = new JTable(tableModelCarrito);
        tablaCarrito.setFont(new Font("Arial", Font.PLAIN, 12));
        tablaCarrito.setRowHeight(25);
        
        JScrollPane scrollCarrito = new JScrollPane(tablaCarrito);
        scrollCarrito.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(52, 73, 94), 2),
            "CARRITO ACTUAL",
            TitledBorder.DEFAULT_JUSTIFICATION,
            TitledBorder.DEFAULT_POSITION,
            new Font("Arial", Font.BOLD, 14),
            new Color(52, 73, 94)
        ));
        panel.add(scrollCarrito, BorderLayout.CENTER);
        
        // Panel de botones del carrito
        JPanel panelBotones = new JPanel(new FlowLayout());
        
        JButton btnRemover = new JButton("Remover Seleccionado");
        btnRemover.setBackground(new Color(231, 76, 60));
        btnRemover.setForeground(Color.BLACK);  // Cambiado a negro
        btnRemover.setFocusPainted(false);
        btnRemover.setFont(new Font("Arial", Font.BOLD, 12));
        
        JButton btnVaciar = new JButton("Vaciar Carrito");
        btnVaciar.setBackground(new Color(241, 196, 15));
        btnVaciar.setForeground(Color.BLACK);  // Cambiado a negro
        btnVaciar.setFocusPainted(false);
        btnVaciar.setFont(new Font("Arial", Font.BOLD, 12));
        
        btnRemover.addActionListener(e -> {
            int selectedRow = tablaCarrito.getSelectedRow();
            if (selectedRow >= 0) {
                String id = (String) tableModelCarrito.getValueAt(selectedRow, 0);
                try {
                    carrito.remover(id);
                    actualizarResumen();
                    actualizarCarrito();
                    actualizarHistorial();
                    JOptionPane.showMessageDialog(this,
                        "Producto removido del carrito",
                        "Exito", JOptionPane.INFORMATION_MESSAGE);
                } catch (Exception ex) {
                    JOptionPane.showMessageDialog(this,
                        ex.getMessage(),
                        "Error", JOptionPane.ERROR_MESSAGE);
                }
            } else {
                JOptionPane.showMessageDialog(this,
                    "Seleccione un producto del carrito",
                    "Advertencia", JOptionPane.WARNING_MESSAGE);
            }
        });
        
        btnVaciar.addActionListener(e -> {
            int confirm = JOptionPane.showConfirmDialog(this,
                "Esta seguro de vaciar el carrito?",
                "Confirmar", JOptionPane.YES_NO_OPTION);
            if (confirm == JOptionPane.YES_OPTION) {
                carrito.vaciar();
                actualizarResumen();
                actualizarCarrito();
                actualizarHistorial();
            }
        });
        
        panelBotones.add(btnRemover);
        panelBotones.add(btnVaciar);
        
        panel.add(panelBotones, BorderLayout.SOUTH);
        
        return panel;
    }
    
    private JPanel crearPanelInferior() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(new EmptyBorder(10, 10, 10, 10));
        panel.setBackground(new Color(236, 240, 241));
        
        // Panel de resumen
        JPanel panelResumen = new JPanel(new GridLayout(2, 2, 10, 5));
        panelResumen.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(52, 73, 94), 2),
            "RESUMEN DE COMPRA",
            TitledBorder.DEFAULT_JUSTIFICATION,
            TitledBorder.DEFAULT_POSITION,
            new Font("Arial", Font.BOLD, 14),
            new Color(52, 73, 94)
        ));
        panelResumen.setBackground(new Color(236, 240, 241));
        
        lblSubtotal = new JLabel("Subtotal: S/0.00", SwingConstants.CENTER);
        lblSubtotal.setFont(new Font("Arial", Font.PLAIN, 14));
        
        lblDescuento = new JLabel("Descuento: S/0.00", SwingConstants.CENTER);
        lblDescuento.setFont(new Font("Arial", Font.PLAIN, 14));
        
        lblImpuesto = new JLabel("IGV (18%): S/0.00", SwingConstants.CENTER);
        lblImpuesto.setFont(new Font("Arial", Font.PLAIN, 14));
        
        lblTotal = new JLabel("TOTAL: S/0.00", SwingConstants.CENTER);
        lblTotal.setFont(new Font("Arial", Font.BOLD, 16));
        lblTotal.setForeground(new Color(46, 204, 113));
        
        panelResumen.add(lblSubtotal);
        panelResumen.add(lblDescuento);
        panelResumen.add(lblImpuesto);
        panelResumen.add(lblTotal);
        
        // Panel de historial
        txtHistorial = new JTextArea(5, 30);
        txtHistorial.setEditable(false);
        txtHistorial.setFont(new Font("Monospaced", Font.PLAIN, 11));
        JScrollPane scrollHistorial = new JScrollPane(txtHistorial);
        scrollHistorial.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(52, 73, 94), 2),
            "HISTORIAL DE OPERACIONES",
            TitledBorder.DEFAULT_JUSTIFICATION,
            TitledBorder.DEFAULT_POSITION,
            new Font("Arial", Font.BOLD, 14),
            new Color(52, 73, 94)
        ));
        
        // Boton finalizar compra
        JButton btnFinalizar = new JButton("FINALIZAR COMPRA");
        btnFinalizar.setBackground(new Color(46, 204, 113));
        btnFinalizar.setForeground(Color.BLACK);  // Cambiado a negro
        btnFinalizar.setFont(new Font("Arial", Font.BOLD, 14));
        btnFinalizar.setFocusPainted(false);
        btnFinalizar.setPreferredSize(new Dimension(200, 40));
        
        btnFinalizar.addActionListener(e -> {
            if (carrito.getCantidadItems() == 0) {
                JOptionPane.showMessageDialog(this,
                    "El carrito esta vacio. Agregue productos antes de finalizar la compra.",
                    "Advertencia", JOptionPane.WARNING_MESSAGE);
                return;
            }
            
            int confirm = JOptionPane.showConfirmDialog(this,
                "Subtotal: S/" + String.format("%.2f", carrito.calcularSubtotal()) +
                "\nTotal a pagar: S/" + String.format("%.2f", carrito.calcularTotal()) +
                "\n\nConfirmar compra?",
                "Finalizar Compra", JOptionPane.YES_NO_OPTION);
            
            if (confirm == JOptionPane.YES_OPTION) {
                JOptionPane.showMessageDialog(this,
                    "COMPRA REALIZADA CON EXITO!\nGracias por su preferencia.",
                    "Exito", JOptionPane.INFORMATION_MESSAGE);
                carrito.vaciar();
                actualizarResumen();
                actualizarCarrito();
                actualizarHistorial();
            }
        });
        
        JPanel panelFinalizar = new JPanel(new FlowLayout(FlowLayout.CENTER));
        panelFinalizar.add(btnFinalizar);
        
        panel.add(panelResumen, BorderLayout.WEST);
        panel.add(scrollHistorial, BorderLayout.CENTER);
        panel.add(panelFinalizar, BorderLayout.EAST);
        
        return panel;
    }
    
    private void actualizarResumen() {
        double subtotal = carrito.calcularSubtotal();
        double total = carrito.calcularTotal();
        double impuesto = total - (subtotal - (subtotal >= 1000 ? subtotal * 0.10 : subtotal >= 500 ? subtotal * 0.05 : 0));
        double descuento = (subtotal >= 1000 ? subtotal * 0.10 : subtotal >= 500 ? subtotal * 0.05 : 0);
        
        lblSubtotal.setText(String.format("Subtotal: S/%.2f", subtotal));
        lblDescuento.setText(String.format("Descuento: S/%.2f", descuento));
        lblImpuesto.setText(String.format("IGV (18%%): S/%.2f", impuesto));
        lblTotal.setText(String.format("TOTAL: S/%.2f", total));
    }
    
    private void actualizarCarrito() {
        tableModelCarrito.setRowCount(0);
        for (ItemCarrito item : carrito.getItems()) {
            Producto p = item.getProducto();
            tableModelCarrito.addRow(new Object[]{
                p.getId(),
                p.getNombre(),
                item.getCantidad(),
                String.format("%.2f", p.getPrecio()),
                String.format("%.2f", item.getSubtotal())
            });
        }
    }
    
    private void actualizarHistorial() {
        StringBuilder sb = new StringBuilder();
        for (String op : carrito.getHistorial()) {
            sb.append(op).append("\n");
        }
        txtHistorial.setText(sb.toString());
        txtHistorial.setCaretPosition(txtHistorial.getDocument().getLength());
    }
    
    private void configurarAtajos() {
        // Atajos de teclado
        getRootPane().registerKeyboardAction(
            e -> System.exit(0),
            KeyStroke.getKeyStroke("control Q"),
            JComponent.WHEN_IN_FOCUSED_WINDOW
        );
    }
    
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception e) {
                e.printStackTrace();
            }
            new CarritoGUI().setVisible(true);
        });
    }
}
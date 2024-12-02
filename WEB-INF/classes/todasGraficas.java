import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class todasGraficas extends HttpServlet {

    // Configuración de la base de datos
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta";
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Conexión a la base de datos
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Consulta para obtener todas las preguntas
            String preguntaSql = "SELECT id, pregunta FROM preguntas";
            String opcionesSql = "SELECT opcion, contador FROM opciones_respuesta WHERE pregunta_id = ?";

            List<BufferedImage> graficos = new ArrayList<>();

            try (PreparedStatement preguntaStmt = connection.prepareStatement(preguntaSql);
                 PreparedStatement opcionesStmt = connection.prepareStatement(opcionesSql)) {

                ResultSet preguntaRs = preguntaStmt.executeQuery();

                while (preguntaRs.next()) {
                    int preguntaId = preguntaRs.getInt("id");
                    String preguntaTitulo = preguntaRs.getString("pregunta");

                    // Obtener opciones y contadores para cada pregunta
                    opcionesStmt.setInt(1, preguntaId);
                    ResultSet opcionesRs = opcionesStmt.executeQuery();

                    // Crear el conjunto de datos para el gráfico
                    DefaultCategoryDataset dataset = new DefaultCategoryDataset();
                    while (opcionesRs.next()) {
                        String opcion = opcionesRs.getString("opcion");
                        int contador = opcionesRs.getInt("contador");
                        dataset.addValue(contador, "Respuestas", opcion);
                    }

                    // Crear gráfico
                    JFreeChart barChart = ChartFactory.createBarChart(
                            "Resultados: " + preguntaTitulo, // Título
                            "Opción",                        // Eje X
                            "Contador",                      // Eje Y
                            dataset,                         // Datos
                            PlotOrientation.VERTICAL,        // Orientación
                            false,                           // Leyenda
                            true,                            // Tooltips
                            false                            // URLs
                    );

                    // Añadir gráfico a la lista como imagen
                    BufferedImage img = barChart.createBufferedImage(800, 600);
                    graficos.add(img);
                }
            }

            // Configurar la respuesta para enviar las imágenes al navegador
            response.setContentType("text/html");
            try (OutputStream out = response.getOutputStream()) {
                StringBuilder html = new StringBuilder();
                html.append("<html><head><title>Graficos de Resultados</title><script src=\"https://cdn.tailwindcss.com\"></script>");
                html.append("<script>");
                html.append("function openModal(imageSrc) {");
                html.append("    const modal = document.getElementById('imageModal');");
                html.append("    const modalImage = document.getElementById('modalImage');");
                html.append("    modal.classList.remove('hidden');");
                html.append("    modalImage.src = imageSrc;");
                html.append("}");
                html.append("function closeModal() {");
                html.append("    const modal = document.getElementById('imageModal');");
                html.append("    modal.classList.add('hidden');");
                html.append("}");
                html.append("</script></head><body class=\"bg-gray-100 font-sans\">");
                html.append("<div class=\"max-w-7xl mx-auto py-6 px-4\">");
                html.append("<h1 class=\"text-3xl font-bold text-center text-gray-800 mb-8\">Resultados de Todas las Encuestas</h1>");
                html.append("<div class=\"text-center mb-6\">");
                html.append("<a href=\"/encuesta/src/panel.jsp\" class=\"inline-block bg-blue-500 text-white px-4 py-2 rounded-lg shadow hover:bg-blue-600\">Regresar al Panel</a>");
                html.append("</div>");
                html.append("<div class=\"grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6\">");
                
                                // Iterar por cada gráfico e incrustarlo como imagen en línea (Base64)
                int count = 1;
                for (BufferedImage img : graficos) {
                    html.append("<div class=\"bg-white shadow-lg rounded-lg p-4\">");
                    html.append("<h2 class=\"text-xl font-semibold text-gray-700 mb-4\">Pregunta " + count + "</h2>");
                    html.append("<div class=\"flex justify-center mb-4\">");
                    html.append("<img src=\"data:image/png;base64," + encodeImageToBase64(img) + "\" alt=\"Gráfico " + count + "\" class=\"rounded-md shadow-md max-w-full h-auto cursor-pointer\" onclick=\"openModal(this.src)\" />");
                    html.append("</div>");
                    html.append("</div>");
                    count++;
                }
                
                html.append("</div>");  // Cierra la grilla
                
                // Modal para mostrar la imagen ampliada
                html.append("<div id=\"imageModal\" class=\"hidden fixed inset-0 bg-gray-900 bg-opacity-75 flex items-center justify-center z-50\">");
                html.append("<div class=\"relative w-full max-w-3xl bg-white p-4 rounded-lg\">");
                html.append("<button onclick=\"closeModal()\" class=\"absolute top-0 right-0 p-2 text-white bg-red-500 rounded-full\">X</button>");
                html.append("<img id=\"modalImage\" class=\"max-w-full h-auto\" />");
                html.append("</div>");
                html.append("</div>");
                
                html.append("</div>");  // Cierra el contenedor principal
                html.append("</body></html>");
                
                out.write(html.toString().getBytes());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al acceder a la base de datos.");
        }
    }

    // Método para codificar la imagen en Base64
    private String encodeImageToBase64(BufferedImage image) throws IOException {
        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
        javax.imageio.ImageIO.write(image, "png", baos);
        byte[] bytes = baos.toByteArray();
        return java.util.Base64.getEncoder().encodeToString(bytes);
    }
}


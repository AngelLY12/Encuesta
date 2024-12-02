import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.DefaultCategoryDataset;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.awt.*;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class grafico extends HttpServlet {

    // Configuración de la conexión a la base de datos
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta"; 
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener el ID de la pregunta desde el parámetro
        int preguntaId = Integer.parseInt(request.getParameter("id"));

        if (preguntaId == 0 ) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El parámetro preguntaId es obligatorio.");
            return;
        }

        // Conexión a la base de datos
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

            // Consulta SQL para obtener la pregunta y sus opciones
            String preguntaSql = "SELECT pregunta FROM preguntas WHERE id = ?";
            String opcionesSql = "SELECT opcion, contador FROM opciones_respuesta WHERE pregunta_id = ?";

            try (PreparedStatement preguntaStmt = connection.prepareStatement(preguntaSql);
                 PreparedStatement opcionesStmt = connection.prepareStatement(opcionesSql)) {

                // Establecer parámetros para las consultas
                preguntaStmt.setInt(1, preguntaId);
                opcionesStmt.setInt(1, preguntaId);

                // Ejecutar la consulta para obtener la pregunta
                ResultSet preguntaRs = preguntaStmt.executeQuery();
                String preguntaTitulo = "";

                if (preguntaRs.next()) {
                    preguntaTitulo = preguntaRs.getString("pregunta");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "La pregunta no existe.");
                    return;
                }

                // Ejecutar la consulta para obtener las opciones y los contadores
                ResultSet opcionesRs = opcionesStmt.executeQuery();

                // Crear el conjunto de datos para el gráfico
                DefaultCategoryDataset dataset = new DefaultCategoryDataset();

                while (opcionesRs.next()) {
                    String opcion = opcionesRs.getString("opcion");
                    int contador = opcionesRs.getInt("contador");
                    dataset.addValue(contador, "Respuestas", opcion);
                }

                // Crear el gráfico de barras
                JFreeChart barChart = ChartFactory.createBarChart(
                        "Resultados: " + preguntaTitulo, // Título
                        "Opción",                        // Eje X
                        "Contador",                      // Eje Y
                        dataset                         // Datos
                );

                // Configurar la respuesta HTTP para enviar la imagen al navegador
                response.setContentType("image/png");
                OutputStream out = response.getOutputStream();

                // Generar la imagen del gráfico
                Image img = barChart.createBufferedImage(800, 600); // Tamaño de la imagen
                javax.imageio.ImageIO.write((java.awt.image.BufferedImage) img, "PNG", out);

                // Cerrar el flujo de salida
                out.close();

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al acceder a la base de datos.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al establecer la conexión a la base de datos.");
        }
    }
}


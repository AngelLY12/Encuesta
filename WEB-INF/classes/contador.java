import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

public class contador extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://127.0.0.1/encuesta";
    private static final String DB_USER = "angel";
    private static final String DB_PASSWORD = "123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Verificar el tipo de contenido
            if (!request.getContentType().startsWith("application/x-www-form-urlencoded")) {
                response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, "Formato de datos no válido.");
                return;
            }

            Class.forName("org.postgresql.Driver");

            try (Connection conexion = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                conexion.setAutoCommit(false); // Iniciar transacción

                for (String paramName : request.getParameterMap().keySet()) {
                    if (paramName.startsWith("respuesta_")) {
                        String respuesta = request.getParameter(paramName);
                        if (respuesta == null || respuesta.isEmpty()) {
                            out.println("<p>Por favor selecciona una respuesta para: " + paramName + "</p>");
                            continue; // Salta al siguiente parámetro
                        }
                        // Validar que la opción exista
                        String validationQuery = "SELECT COUNT(*) FROM opciones_respuesta WHERE opcion = ?";
                        try (PreparedStatement validationPs = conexion.prepareStatement(validationQuery)) {
                            validationPs.setString(1, respuesta);
                            try (ResultSet rs = validationPs.executeQuery()) {
                                if (rs.next() && rs.getInt(1) > 0) {
                                    String updateQuery = "UPDATE opciones_respuesta SET contador = contador + 1 WHERE opcion = ?";
                                    try (PreparedStatement ps = conexion.prepareStatement(updateQuery)) {
                                        ps.setString(1, respuesta);
                                        ps.executeUpdate();
                                    }
                                } else {
                                    out.println("<p>Opción no válida: " + respuesta + "</p>");
                                }
                            }
                        }
                    }
                }

                conexion.commit(); // Confirmar cambios
                response.sendRedirect(request.getContextPath() + "/src/enviado.jsp");
            } catch (SQLException e) {
                e.printStackTrace(out);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la encuesta.");
            }
        } catch (Exception e) {
            e.printStackTrace(out);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error inesperado.");
        }
    }
}



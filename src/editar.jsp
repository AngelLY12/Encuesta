<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Pregunta</title>
    <link href="./output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
    <% 
        // Recuperar el ID de la pregunta a editar desde los parámetros de la URL
        int preguntaId = Integer.parseInt(request.getParameter("id"));

        // Configuración de la conexión a la base de datos
        String url = "jdbc:postgresql://127.0.0.1/encuesta";
        String username = "angel";
        String password = "123";

        // Declarar conexión y objetos
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Establecer la conexión
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, username, password);

            // Consultar la pregunta y sus opciones asociadas
            String queryPregunta = "SELECT id, pregunta, estado FROM preguntas WHERE id = ?";
            stmt = conn.prepareStatement(queryPregunta);
            stmt.setInt(1, preguntaId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String pregunta = rs.getString("pregunta");
                String estado = rs.getString("estado");

                // Consultar las opciones de respuesta
                String queryOpciones = "SELECT opcion FROM opciones_respuesta WHERE pregunta_id = ?";
                PreparedStatement stmtOpciones = conn.prepareStatement(queryOpciones);
                stmtOpciones.setInt(1, preguntaId);
                ResultSet rsOpciones = stmtOpciones.executeQuery();

                // Guardar las opciones en una lista
                List<String> opciones = new ArrayList<>();
                while (rsOpciones.next()) {
                    opciones.add(rsOpciones.getString("opcion"));
                }

%>
    <div class="container mx-auto p-6">
        <h1 class="text-3xl font-semibold mb-6">Actualizar Pregunta</h1>
        
        <!-- Formulario de actualización de preguntas -->
        <form action="<%= request.getContextPath() %>/update" method="POST" class="bg-white shadow-md rounded-lg p-6">
            <!-- Campo para la pregunta -->
            <div class="mb-4">
                <label for="id" class="block text-gray-700 font-medium">Id</label>
                <input type="number" id="id" name="id" value="<%= preguntaId %>" required readonly 
                    class="mt-2 w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div class="mb-4">
                <label for="pregunta" class="block text-gray-700 font-medium">Pregunta</label>
                <input type="text" id="pregunta" name="pregunta" value="<%= pregunta %>" required 
                    class="mt-2 w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <!-- Opciones de respuesta -->
            <div class="mb-4">
                <label class="block text-gray-700 font-medium">Opciones de Respuesta</label>
                <div class="space-y-2 mt-2">
                    <% for (int i = 0; i < opciones.size(); i++) { %>
                        <input type="text" name="opcion<%= i+1 %>" value="<%= opciones.get(i) %>" required 
                               class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <% } %>
                </div>
            </div>

            <div class="flex justify-end items-center mb-6">
                <div>
                    <button type="submit" class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">Actualizar Pregunta</button>
                    <button onclick="window.location.href='/encuesta/src/panel.jsp'" class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500">Cancelar</button>
                </div>
                
            </div>
        </form>
    </div>

<% 
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
%>
</body>
</html>

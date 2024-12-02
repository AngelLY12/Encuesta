<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Gráfico de Resultados</title>
    <link href="./output.css" rel="stylesheet">

</head>
<body class="bg-gray-100 font-sans">
    <% 
        // Recuperar el ID de la pregunta a editar desde los parámetros de la URL
        int preguntaId = Integer.parseInt(request.getParameter("id"));
    %>
    <div class="max-w-4xl mx-auto px-4 py-6">
        <h1 class="text-3xl font-bold text-center text-gray-800 mb-6">Resultados de la Encuesta</h1>

        <!-- Contenedor del gráfico -->
        <div class="bg-white shadow-lg rounded-lg p-6 mb-6">
            <!-- Campo oculto para el ID de la pregunta -->
            <div class="mb-4 hidden">
                <label for="id" class="block text-gray-700 font-medium">Id</label>
                <input type="number" id="id" name="id" value="<%= preguntaId %>" required readonly 
                    class="mt-2 w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>

            <!-- Imagen del gráfico generado -->
            <div class="flex justify-center">
                <img src="<%= request.getContextPath() %>/grafico?id=<%= preguntaId %>" alt="Gráfico de Resultados" class="rounded-lg shadow-md max-w-full h-auto" />
            </div>
        </div>

        <!-- Botón para regresar -->
        <div class="text-center mb-6">
            <button onclick="window.location.href='/encuesta/src/panel.jsp'" class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-6 rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-blue-500">Regresar a la Encuesta</button>
        </div>
    </div>
</body>
</html>

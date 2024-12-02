<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gracias por contestar</title>
    <!-- Enlace a Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 h-screen flex items-center justify-center">

    <div class="bg-white p-8 rounded-lg shadow-lg text-center">
        <h1 class="text-2xl font-bold text-green-500">¡Gracias por contestar el formulario!</h1>
        <p class="mt-4 text-gray-600">Tu respuesta ha sido registrada correctamente.</p>
        <form action="<%= request.getContextPath() %>/src/index.jsp" method="get" class="mt-6">
            <button type="submit" class="bg-green-500 text-white px-6 py-2 rounded-lg hover:bg-green-600 transition duration-200">Volver a contestar</button>
        </form>
    </div>

</body>
</html>

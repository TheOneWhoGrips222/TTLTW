function changeImage(imgElement) {
    const mainImage = document.getElementById("mainImage");
    mainImage.src = imgElement.src;

    document.querySelectorAll(".product-thumbnails img")
        .forEach(img => img.classList.remove("active"));

    imgElement.classList.add("active");
}

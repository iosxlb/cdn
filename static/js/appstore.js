let searchCountry = 'cn';

let appListArr = []

function app(itunes) {
    const appLists = document.querySelector('#app-list');
    const appList = document.querySelector('.app-list-box');
    const appListDig = document.querySelector('.dig_box_big .app-list-dig');
    appList.innerHTML = '';
    appListArr = itunes.results

    for (let i in appListArr) {
        if (appListArr[i].wrapperType === 'software') {
            const formattedDescription = appListArr[i].description.replace(/\n\n|\n\s+|\n/g, '<br>');
            const curItem = `
            <div class="app-container" onclick="toggleDescription(event, this)">
                <div class="app-icon">
                    <a href="${appListArr[i].artworkUrl512.replace("512x512bb", "1024x1024bb")}">
                        <img src="${itunes.results[i].artworkUrl512}" width="64">
                    </a>
                </div>
                <div class="app-info">
<div class="app-name" onclick="copyText(event, '${itunes.results[i].trackName}')"> 
${itunes.results[i].trackName} 
</div>
<div class="app-description">${formattedDescription}</div>
<div class="app-version">
<span class="bundle-id" onclick="copyText(event, '${itunes.results[i].bundleId}')">标识符: ${itunes.results[i].bundleId}</span>
<span class="version" onclick="copyText(event, '${itunes.results[i].version}')">版本: ${itunes.results[i].version}</span>
</div>
</div>
<div class="button-group"> 
<button class="install-button" onclick="window.location.href='${itunes.results[i].trackViewUrl}'">安装</button>
<button class="copy-button" onclick="copyLink(event, '${itunes.results[i].trackId}')">复制</button>
</div>
            </div>
        `;
            if (i < 2) {
                appList.innerHTML += curItem
                appLists.style.display = 'block'
            }
            appListDig.innerHTML += curItem
        }
    }
}

function copyLink(event, trackId) {
    event.preventDefault();
    const link = searchCountry == 'cn' ?
        `https://icon.25tl.cn/app-icon/?id=${trackId}` :
        `https://icon.25tl.cn/app-icon/us?id=${trackId}`;

    navigator.clipboard.writeText(link)
        .then(() => {
            const alertDiv = document.createElement('div');
            alertDiv.textContent = '图片链接复制成功！';
            alertDiv.style.position = 'fixed';
            alertDiv.style.top = '20px';
            alertDiv.style.left = '50%';
            alertDiv.style.transform = 'translateX(-50%)';
            alertDiv.style.backgroundColor = '#4CAF50';
            alertDiv.style.color = 'white';
            alertDiv.style.padding = '10px 20px';
            alertDiv.style.borderRadius = '5px';
            alertDiv.style.zIndex = '1000';
            document.body.appendChild(alertDiv);
            setTimeout(() => {
                alertDiv.remove();
            }, 2000);
        })
        .catch(err => {
            console.error('复制失败：', err);
        });
}

function copyText(event, text) {
    event.stopPropagation();
    navigator.clipboard.writeText(text)
        .then(() => {
            const alertDiv = document.createElement('div');
            alertDiv.textContent = '复制成功: ' + text;
            alertDiv.style.position = 'fixed';
            alertDiv.style.top = '20px';
            alertDiv.style.left = '50%';
            alertDiv.style.transform = 'translateX(-50%)';
            alertDiv.style.backgroundColor = '#4CAF50';
            alertDiv.style.color = 'white';
            alertDiv.style.padding = '10px 20px';
            alertDiv.style.borderRadius = '5px';
            document.body.appendChild(alertDiv);
            setTimeout(() => {
                alertDiv.remove();
            }, 2000);
        })
        .catch(err => {
            console.error('复制失败：', err);
        });
}

function toggleDescription(event, container) {
    if (event.target.classList.contains('copy-button') || event.target.classList.contains('install-button')) {
        return;
    }
    container.querySelector('.app-info').classList.toggle('show-full-description');
}

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('searchForm').addEventListener('submit', function (e) {
        e.preventDefault();
        const searchTerm = document.querySelector('input[name="s"]').value;
        const action = e.submitter.value;
        const scriptTag = document.createElement('script');
        if (action === "搜索国区应用") {
            searchCountry = 'cn';
            scriptTag.src = `https://itunes.apple.com/cn/search?term=${searchTerm}&country=cn&entity=software&sort=recent&limit=200&callback=app`;
        } else if (action === "搜索外区应用") {
            searchCountry = 'us';
            scriptTag.src = `https://itunes.apple.com/us/search?term=${searchTerm}&country=us&entity=software&sort=recent&limit=200&callback=app`;
        }
        document.body.appendChild(scriptTag);
    });

    document.querySelector('.appListMore').onclick = (e) => {
        e.stopPropagation()
        document.querySelector('.dig_box_big').style.display = 'flex'
    }

    document.querySelector('body').onclick=()=>{
        document.querySelectorAll('.dig_box')[0].style.display = 'none'
        document.querySelectorAll('.dig_box')[1].style.display = 'none'
    }

    $('.dig_box .dig_contact').on('click',function(e){
        e.stopPropagation()
    })
});

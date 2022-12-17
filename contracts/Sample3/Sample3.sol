// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2022 nawoo (@NowAndNawoo)

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../common/IDataChunkCompilerV2.sol";

contract Sample3 is ERC721("Sample3", "SAMPLE3"), Ownable {
    using Strings for uint256;

    IDataChunkCompilerV2 private compiler;
    address[9] private threeAddresses;
    string private constant STYLE_CODE =
        "%253Cstyle%253E%252A%257Bmargin%253A0%253Bpadding%253A0%257Dcanvas%257Bwidth%253A100%2525%253Bheight%253A100%2525%257D%253C%252Fstyle%253E";
    string private constant JS_CODE =
        "const%2520sidePath%253D%2522data%253Aimage%252Fpng%253Bbase64%252CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8%252F9hAAAAAXNSR0IArs4c6QAAAi9JREFUOI1tk89rE0EUxz%252FZkmo3QlJoLkLSlBrSNJZAQmvDSk8eerEUoWmh13rw0n%252FAIqV4F8RDRPEmFHsQ9C4YXFaQLQRp16BgslMQsTath42WYjzEeW3Quczw5vve98fshq48WO0Ux6sA5DMpavUGza0Owwshmlsd5tZGqNUbnF1v7wwwvdGmudXBKI5XcXdnAHi4%252BBWA4YWQ7HqgXu7ujDQPL4Qwzk6e3mjLOZ9J4e7OkM%252BkZGA%252Bk0Kr1TUDYKnqigrN9uLuZ4rj1R75T54nAUhXIoIXBUM7r4UtXYkwtzYioHQlAiDs%252BpyuRDAWN6cAuPb9ArV6Q8C1eoOlqsvJ7RCeCqSudwBPBRiPPr0BoBDL9SS9uDmFpwKyCZNswpTmQiwnA1fKY10LhViOp%252B%252Ffka5EsEpdn9uHO2QTJp4KcPdb3RfYb7F9uMNKeQwA2%252FExikODAgZ4%252FOxDj8RswqQ4NIhVSmK2z%252F2DMQBh1Q2acXliUoC244uilfIYngq6GRRiOWzHxyolRcXq9TyeCtD5eCqQQcsTk9iOTzDwi2zCpK%252B%252F%252F%252Fd6PBpG7R2Jz5ODY%252BZnRzk5OAYgHg1jlZKovSNefWwSj4a5aA5glZIYyxOTwuCpgJuXropPTwViz3Z8gB6LtuPTlx89vz4%252FO4raOyIeDfPl5zfc%252FRa3blym%252FSMQZZ4KRIlWVojlCN0rW6d%252Fyt9ANdv%252F6jpoeYWzAXkqwHZ8%252Baj0nVVKcv9lradZY%252F4AGkoIRULmBlkAAAAASUVORK5CYII%253D%2522%252CtopPath%253D%2522data%253Aimage%252Fpng%253Bbase64%252CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8%252F9hAAAAAXNSR0IArs4c6QAAAYZJREFUOI1tk79Kw1AUh78b69BRaAcrNNkCrRIhiE7pK%252BgQcO7o4CMUKT6Ci0tnIUPBBxCaqSgZOhhwEI2gIFRw0sEhDuHc3qQ5y%252F2T38m53%252B%252Beq87u9nOMSNKAv5sHtvd%252BsENFFuXYocJzHW4vX7BDRZIG%252BL2YLMppVJP9XgxjAAWAHRbjZNrFD19NOXaosLKoOMB81KT1OAPAcx1kP0kDquH3Yq1RguC5DouncgU5kYyi8VxHa9Th1Xnu9%252BLaRHMuXlTDMpOTNCBJA41iVl72B1pn4qnr9%252BN8Mu0yPHkrIQi7FKhDBNj4uN%252B62NjdwbIWpQ%252Bddkannen159c3WZTzrAalfeto%252FKuPbEbdLSz7A6rIDSjucz5qsnl6AEDrcbZmmGmsICUpWHIlR%252BNfzSydJ2vPdUrGZlGu%252FWjIpEhYVVg8vZKkwZq5ZrNBjCWMIjKZhydvTKZdBNPsBdFbVS6zgczKnuvoh7TsD5iPmgCrVpYQ9%252Bu6rs5MjSCjHapSsuzLjyVZ1v%252BSNdQ60Dwq2AAAAABJRU5ErkJggg%253D%253D%2522%252CbottomPath%253D%2522data%253Aimage%252Fpng%253Bbase64%252CiVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8%252F9hAAAAAXNSR0IArs4c6QAAAflJREFUOI1tk79L42AYxz%252BNp16ztIW6CI1DOyT0pF6LQ0l3XQS5IYtrKtzi3%252BB%252FcHCrri6ut90gHFgClhSklAhmMSncEi6pPVI8j%252BsN5X2J1XcJed%252Fv%252B%252F3xPM%252BbO25%252FnAMYFRWx3CimVS7hRjHdWodBMiK7zLZGzwlwoxjFqKik%252BSd54IUprXIJgJODBoNkhNnW5GUvTDm%252FvMNsa7TKJXJfLHPuhekLBwDNYp2LYZ%252Bj7V0GyYi3MACKsO%252BFqVQAOPOvMSoqF8M%252By5gsThE%252FtqXTLNYlsFvrSNVsBBFVuMn9OD6eZ4u0bFUovWXfC1OUM%252F9aZs4qNYt1SbZMKEhtS19EEAXrOQG2pQMwSEYyjhvFwKK9RkWVmJ4ToLTKJQkGOL%252B8exWnVS5htjXU2forjOKFqey%252FuCAUs3F6TiAd2ZYu8crR9q60LlycHDTwwlQOWN6YyuoLfJp%252FwrZ0VtbW%252Fp1uFFb57vwkenwmeP7N319%252FONyvMrxN2Nva4cb3AQjHE67uH9jb2iGnTNEqhYWDbLW7tc6LnHljihvFNIt12U7RuZ4TsNKovj893K8SjieYbY0b38eNYj5%252F%252BsDsMSUcT9hU81zdP7BRWAVgU83L2iiCSXzFIxF7Qlm0LjvOg2TEu%252BzkLQ4DmsW6fEBe2Me2dL5%252Bu0WdrUusIP4PMoAQ8lL2wooAAAAASUVORK5CYII%253D%2522%253Bwindow.onload%253D()%253D%253E%257Bconst%2520A%253D%257Bwidth%253Awindow.innerWidth%252Cheight%253Awindow.innerHeight%257D%252Ce%253Dnew%2520THREE.Scene%252Ci%253D(e.background%253Dnew%2520THREE.Color(4214928)%252Cnew%2520THREE.PerspectiveCamera(75%252CA.width%252FA.height%252C.1%252C1e3))%252Ct%253D(i.position.z%253D2%252Ci.lookAt(0%252C0%252C0)%252Cnew%2520THREE.WebGLRenderer)%253Bt.setSize(A.width%252CA.height)%252Ct.setPixelRatio(window.devicePixelRatio)%252Cdocument.body.appendChild(t.domElement)%253Bvar%2520a%253Dnew%2520THREE.BoxGeometry%252Cn%253Dnew%2520THREE.TextureLoader%252Co%253Dn.load(sidePath)%252Cr%253D(o.magFilter%253DTHREE.NearestFilter%252Cn.load(topPath))%252Cn%253D(r.magFilter%253DTHREE.NearestFilter%252Cn.load(bottomPath))%252Cr%253D(n.magFilter%253DTHREE.NearestFilter%252C%255Bnew%2520THREE.MeshBasicMaterial(%257Bmap%253Ao%257D)%252Cnew%2520THREE.MeshBasicMaterial(%257Bmap%253Ao%257D)%252Cnew%2520THREE.MeshBasicMaterial(%257Bmap%253Ar%257D)%252Cnew%2520THREE.MeshBasicMaterial(%257Bmap%253An%257D)%252Cnew%2520THREE.MeshBasicMaterial(%257Bmap%253Ao%257D)%252Cnew%2520THREE.MeshBasicMaterial(%257Bmap%253Ao%257D)%255D)%253Bfunction%2520w()%257BrequestAnimationFrame(w)%252Ct.render(e%252Ci)%257Dconst%2520h%253Dnew%2520THREE.Mesh(a%252Cr)%253Be.add(h)%252Cwindow.addEventListener(%2522resize%2522%252C()%253D%253E%257BA.width%253Dwindow.innerWidth%252CA.height%253Dwindow.innerHeight%252Ci.aspect%253DA.width%252FA.height%252Ci.updateProjectionMatrix()%252Ct.setSize(A.width%252CA.height)%252Ct.setPixelRatio(window.devicePixelRatio)%257D)%252Cwindow.addEventListener(%2522mousemove%2522%252Ce%253D%253E%257Bh.rotation.y%253D(e.clientX%252FA.width-.5)*Math.PI%252Ch.rotation.x%253D(e.clientY%252FA.height-.5)*Math.PI%257D)%253Bw()%257D%253B";

    function setCompilerAddress(address newAddress) public onlyOwner {
        compiler = IDataChunkCompilerV2(newAddress);
    }

    function setThreeAddress(
        address chunk1,
        address chunk2,
        address chunk3,
        address chunk4,
        address chunk5,
        address chunk6,
        address chunk7,
        address chunk8,
        address chunk9
    ) public onlyOwner {
        threeAddresses[0] = chunk1;
        threeAddresses[1] = chunk2;
        threeAddresses[2] = chunk3;
        threeAddresses[3] = chunk4;
        threeAddresses[4] = chunk5;
        threeAddresses[5] = chunk6;
        threeAddresses[6] = chunk7;
        threeAddresses[7] = chunk8;
        threeAddresses[8] = chunk9;
    }

    function mint(uint256 tokenId) public onlyOwner {
        _mint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory threejs = compiler.compile9(
            threeAddresses[0],
            threeAddresses[1],
            threeAddresses[2],
            threeAddresses[3],
            threeAddresses[4],
            threeAddresses[5],
            threeAddresses[6],
            threeAddresses[7],
            threeAddresses[8]
        );
        string memory tokenIdStr = tokenId.toString();
        return
            string.concat(
                compiler.BEGIN_JSON(),
                string.concat(
                    compiler.BEGIN_METADATA_VAR("animation_url", false),
                    compiler.HTML_HEAD(),
                    STYLE_CODE,
                    string.concat(
                        // Three.js
                        compiler.BEGIN_SCRIPT_DATA_COMPRESSED(),
                        threejs,
                        compiler.END_SCRIPT_DATA_COMPRESSED()
                    ),
                    string.concat(
                        // variable
                        compiler.BEGIN_SCRIPT(),
                        compiler.SCRIPT_VAR("tokenId", tokenIdStr, true),
                        compiler.END_SCRIPT(),
                        // main script
                        compiler.BEGIN_SCRIPT(),
                        JS_CODE,
                        compiler.END_SCRIPT()
                    ),
                    compiler.END_METADATA_VAR(false)
                ),
                string.concat(compiler.BEGIN_METADATA_VAR("name", false), name(), "%20%23", tokenIdStr, "%22"),
                compiler.END_JSON()
            );
    }
}

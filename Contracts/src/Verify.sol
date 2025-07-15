// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { EC, ECPoint as G1Point } from "../src/EC.sol";

// coefficients follow the order in the Solidity precompile
struct G2Point {
    uint256[2] x; // [a1,a0] -> a0 + a1*i
    uint256[2] y; // [a1,a0] -> a0 + a1*i
}

contract Verify is EC {
    G1Point _Alpha1 =
        G1Point(
            10744596414106452074759370245733544594153395043370666422502510773307029471145,
            848677436511517736191562425154572367705380862894644942948681172815252343932
        );

    G2Point _Beta2 =
        G2Point(
            [
                12345624066896925082600651626583520268054356403303305150512393106955803260718,
                10191129150170504690859455063377241352678147020731325090942140630855943625622
            ],
            [
                13790151551682513054696583104432356791070435696840691503641536676885931241944,
                16727484375212017249697795760885267597317766655549468217180521378213906474374
            ]
        );

    G2Point _Gamma2 =
        G2Point(
            [
                18556147586753789634670778212244811446448229326945855846642767021074501673839,
                18936818173480011669507163011118288089468827259971823710084038754632518263340
            ],
            [
                13775476761357503446238925910346030822904460488609979964814810757616608848118,
                18825831177813899069786213865729385895767511805925522466244528695074736584695
            ]
        );

    G2Point _Delta2 =
        G2Point(
            [
                1513450333913810775282357068930057790874607011341873340507105465411024430745,
                11166086885672626473267565287145132336823242144708474818695443831501089511977
            ],
            [
                20245151454212206884108313452940569906396451322269011731680309881579291004202,
                10576778712883087908382530888778326306865681986179249638025895353796469496812
            ]
        );

    function verify(
        G1Point calldata A1,
        G2Point calldata B2,
        G1Point calldata C1,
        uint256 x1,
        uint256 x2,
        uint256 x3
    ) public view returns (bool verified) {
        return
            _verify(A1, B2, _Alpha1, _Beta2, _Gamma2, C1, _Delta2, x1, x2, x3);
    }

    function _verify(
        G1Point calldata A1,
        G2Point calldata B2,
        G1Point memory Alpha1,
        G2Point memory Beta2,
        G2Point memory Gamma2,
        G1Point calldata C1,
        G2Point memory Delta2,
        uint256 x1,
        uint256 x2,
        uint256 x3
    ) private view returns (bool) {
        (uint256 X1x, uint256 X1y) = scalarMultiply(G.x, G.y, x1 + x2 + x3);

        bytes memory payload = abi.encode(
            A1.x,
            A1.y,
            B2.x[0],
            B2.x[1],
            B2.y[0],
            B2.y[1],
            Alpha1.x,
            Alpha1.y,
            Beta2.x[0],
            Beta2.x[1],
            Beta2.y[0],
            Beta2.y[1],
            X1x,
            X1y,
            Gamma2.x[0],
            Gamma2.x[1],
            Gamma2.y[0],
            Gamma2.y[1],
            C1.x,
            C1.y,
            Delta2.x[0],
            Delta2.x[1],
            Delta2.y[0],
            Delta2.y[1]
        );

        (bool ok, bytes memory response) = address(8).staticcall(payload);
        require(ok, "verify failed");
        return abi.decode(response, (bool));
    }
}

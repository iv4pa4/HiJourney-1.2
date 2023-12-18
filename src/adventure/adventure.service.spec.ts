import { Test, TestingModule } from '@nestjs/testing';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { Adventure } from './adventure.entity';

jest.mock('./adventure.service');

describe('AdventureController', () => {
  let controller: AdventureController;
  let adventureService: AdventureService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdventureController],
      providers: [AdventureService],
    }).compile();

    controller = module.get<AdventureController>(AdventureController);
    adventureService = module.get<AdventureService>(AdventureService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get all adventures', async () => {
    const adventures: Adventure[] = [{ id: 1, name: 'Adventure 1', description: 'Description 1' }];
    
    jest.spyOn(adventureService, 'findAll').mockResolvedValue(adventures);

    expect(await controller.findAll()).toBe(adventures);
  });

  // Add more test cases for other controller methods
});
